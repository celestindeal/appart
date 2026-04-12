using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImmoManager.Application.DTOs.Loans;
using ImmoManager.Application.Services.Interfaces;

namespace ImmoManager.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class LoansController : ControllerBase
{
    private readonly ILoanService _loanService;

    public LoansController(ILoanService loanService)
    {
        _loanService = loanService;
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    /// GET /api/loans?propertyId={id}
    [HttpGet]
    [ProducesResponseType(typeof(List<LoanDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<List<LoanDto>>> GetByProperty([FromQuery] Guid propertyId)
    {
        var loans = await _loanService.GetByPropertyAsync(propertyId, GetUserId());
        return Ok(loans);
    }

    /// GET /api/loans/{id}
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(LoanDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<LoanDto>> GetById(Guid id)
    {
        var loan = await _loanService.GetByIdAsync(id, GetUserId());
        if (loan is null) return NotFound();
        return Ok(loan);
    }

    /// POST /api/loans
    [HttpPost]
    [ProducesResponseType(typeof(LoanDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<LoanDto>> Create([FromBody] CreateLoanRequest request)
    {
        var loan = await _loanService.CreateAsync(request, GetUserId());
        return CreatedAtAction(nameof(GetById), new { id = loan.Id }, loan);
    }

    /// PUT /api/loans/{id}
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(LoanDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<LoanDto>> Update(Guid id, [FromBody] UpdateLoanRequest request)
    {
        var loan = await _loanService.UpdateAsync(id, request, GetUserId());
        if (loan is null) return NotFound();
        return Ok(loan);
    }

    /// DELETE /api/loans/{id}
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _loanService.DeleteAsync(id, GetUserId());
        if (!deleted) return NotFound();
        return NoContent();
    }
}
