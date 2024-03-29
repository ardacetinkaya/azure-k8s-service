using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.DataProtection;
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
            Environment = env;
        }

        public IConfiguration Configuration { get; }
        public IHostEnvironment Environment { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            
            services.AddHttpClient("backend", c =>
            {
                var host = Configuration["PRIVATE_BACKEND_SERVICE_HOST"];
                var port = Configuration["PRIVATE_BACKEND_SERVICE_PORT"];

                if(Environment.IsDevelopment())
                {
                    host = Configuration["BACKEND_SERVICE_HOST"];
                    port = Configuration["BACKEND_SERVICE_PORT"];
                }

                var uri = $"http://{host}:{port}";
                
                c.BaseAddress = new Uri(uri);
            });
            services.AddRazorPages();
            services.AddDataProtection()
                .SetApplicationName("SomeFrontEndApp")
                .PersistKeysToFileSystem(new DirectoryInfo(@$"{Configuration.GetValue<string>("UploadDirectory")}"));
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
