using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;


namespace SampleApp
{
    public class Startup
    {
        public Startup(IConfiguration configuration, Microsoft.Extensions.Hosting.IHostEnvironment env)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }
        public IHostEnvironment Environment { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            
            services.AddHttpClient("backend", c =>
            {
                var host = Environment.IsDevelopment()? Configuration["BACKEND_SERVICE_HOST"]:Configuration["PRIVATE_BACKEND_SERVICE_HOST"];
                var port = Environment.IsDevelopment()? Configuration["BACKEND_SERVICE_PORT"]:Configuration["PRIVATE_BACKEND_SERVICE_PORT"];
                
                var uri = $"http://{host}:{port}";
                
                c.BaseAddress = Configuration.GetServiceUri("private-backend");//new Uri(uri);
            });
            services.AddRazorPages();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapRazorPages();
            });
        }
    }
}
