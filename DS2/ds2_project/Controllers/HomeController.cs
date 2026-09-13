using System.Diagnostics;
using ds2_project.DAOs;
using ds2_project.DTOs;
using ds2_project.Models;
using Microsoft.AspNetCore.Mvc;

namespace ds2_project.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly ShopDao _shopDao;

        public HomeController(ILogger<HomeController> logger, ShopDao shopDao)
        {
            _logger = logger;
            _shopDao = shopDao;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public async Task<IActionResult> Products()
        {
            return View(await _shopDao.GetProductsAsync());
        }

        public async Task<IActionResult> Orders()
        {
            return View(await _shopDao.GetOrdersAsync());
        }

        public async Task<IActionResult> Warehouses()
        {
            var page = new WarehousePageDto
            {
                Warehouses = await _shopDao.GetWarehousesAsync(),
                Stock = await _shopDao.GetStockAsync()
            };

            return View(page);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
