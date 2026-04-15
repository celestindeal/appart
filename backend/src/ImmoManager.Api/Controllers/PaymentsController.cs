using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Tenants;
using ImmoManager.Application.Services.Interfaces;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class PaymentsController : ControllerBase
{
    private readonly IPaymentService _paymentService;

    public PaymentsController(IPaymentService paymentService)
    {
        _paymentService = paymentService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// GET /api/payments?tenantId={id}
    [HttpGet]
    [ProducesResponseType(typeof(List<RentPaymentDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<List<RentPaymentDto>>> GetByTenant([FromQuery] Guid tenantId)
    {
        var payments = await _paymentService.GetByTenantAsync(tenantId, GetUserId());
        return Ok(payments);
    }

    /// GET /api/payments/{id}
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(RentPaymentDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<RentPaymentDto>> GetById(Guid id)
    {
        var payment = await _paymentService.GetByIdAsync(id, GetUserId());
        if (payment is null) return NotFound();
        return Ok(payment);
    }

    /// POST /api/payments
    [HttpPost]
    [ProducesResponseType(typeof(RentPaymentDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<RentPaymentDto>> Create([FromBody] CreatePaymentRequest request)
    {
        try
        {
            var payment = await _paymentService.CreateAsync(request, GetUserId());
            return CreatedAtAction(nameof(GetById), new { id = payment.Id }, payment);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    /// PUT /api/payments/{id}
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(RentPaymentDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<RentPaymentDto>> Update(Guid id, [FromBody] UpdatePaymentRequest request)
    {
        var payment = await _paymentService.UpdateAsync(id, request, GetUserId());
        if (payment is null) return NotFound();
        return Ok(payment);
    }

    /// DELETE /api/payments/{id}
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _paymentService.DeleteAsync(id, GetUserId());
        if (!deleted) return NotFound();
        return NoContent();
    }
}
