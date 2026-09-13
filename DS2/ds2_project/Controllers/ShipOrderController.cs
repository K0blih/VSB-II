using ds2_project.DAOs;
using ds2_project.DTOs;
using Microsoft.AspNetCore.Mvc;
using Oracle.ManagedDataAccess.Client;

namespace ds2_project.Controllers
{
    public class ShipOrderController : Controller
    {
        private readonly ShipOrderDao _shipOrderDao;

        public ShipOrderController(ShipOrderDao shipOrderDao)
        {
            _shipOrderDao = shipOrderDao;
        }

        [HttpGet]
        public IActionResult Index()
        {
            return View(new ShipOrderDto());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Index(ShipOrderDto request)
        {
            if (!ModelState.IsValid)
            {
                return View(request);
            }

            try
            {
                await _shipOrderDao.ShipOrderAsync(request.OrderId!.Value, request.WarehouseId!.Value);
                ViewData["SuccessMessage"] = "Order shipped successfully.";
            }
            catch (OracleException ex)
            {
                ModelState.AddModelError(string.Empty, $"Oracle error: {ex.Message}");
            }
            catch (InvalidOperationException ex)
            {
                ModelState.AddModelError(string.Empty, ex.Message);
            }

            return View(request);
        }
    }
}
