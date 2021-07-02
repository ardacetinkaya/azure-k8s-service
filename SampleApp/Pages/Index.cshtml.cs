using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;


namespace SampleApp.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        private readonly IHttpClientFactory _clientFactory;
        private readonly IConfiguration _configuration;
        public IEnumerable<WeatherForecast> Forecasts { get; private set; }

        public string DebugView { get; set; }

        public IndexModel(ILogger<IndexModel> logger, IHttpClientFactory clientFactory, IConfiguration configuration)
        {
            _logger = logger;
            _clientFactory = clientFactory;
            _configuration = configuration;

        }

        public async Task OnGet()
        {
            try
            {
                DebugView = ((IConfigurationRoot)_configuration).GetDebugView();
                var request = new HttpRequestMessage(HttpMethod.Get, "weatherforecast");
                var client = _clientFactory.CreateClient("backend");

                var response = await client.SendAsync(request);
                if (response.IsSuccessStatusCode)
                {
                    var responseStream = await response.Content.ReadAsStringAsync();
                    Forecasts = JsonSerializer.Deserialize<IEnumerable<WeatherForecast>>(responseStream, new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    });
                }

                
            }
            catch (System.Exception ex)
            {
                _logger.LogError($"!!!ERROR!!! - {ex.Message}");
            }

        }
    }
}
