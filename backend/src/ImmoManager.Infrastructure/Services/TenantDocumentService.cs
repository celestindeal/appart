using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using ImmoManager.Application.DTOs.Documents;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Services;

public class TenantDocumentService : ITenantDocumentService
{
    private readonly ImmoManagerDbContext _context;
    private readonly IFileStorageService _storage;

    public TenantDocumentService(ImmoManagerDbContext context, IFileStorageService storage)
    {
        _context = context;
        _storage = storage;
    }

    public async Task<List<DocumentDto>> GetByTenantAsync(Guid tenantId, Guid userId)
    {
        var docs = await _context.TenantDocuments
            .Include(d => d.Tenant).ThenInclude(t => t.Property)
            .Where(d => d.TenantId == tenantId && d.Tenant.Property.UserId == userId)
            .OrderByDescending(d => d.CreatedAt)
            .ToListAsync();

        return docs.Select(MapToDto).ToList();
    }

    public async Task<DocumentDto> UploadAsync(Guid tenantId, IFormFile file, DocumentType type, Guid userId)
    {
        var tenant = await _context.Tenants
            .Include(t => t.Property)
            .FirstOrDefaultAsync(t => t.Id == tenantId && t.Property.UserId == userId);

        if (tenant == null)
            throw new ArgumentException("Le locataire n'existe pas.");

        var stored = await _storage.SaveAsync(file, $"tenants/{tenantId}");

        var doc = new TenantDocument
        {
            TenantId = tenantId,
            DocumentType = type.ToString(),
            FileName = file.FileName,
            FileUrl = stored.FileUrl,
            FileSize = stored.FileSize,
        };

        _context.TenantDocuments.Add(doc);
        await _context.SaveChangesAsync();

        return MapToDto(doc);
    }

    public async Task<bool> DeleteAsync(Guid documentId, Guid userId)
    {
        var doc = await _context.TenantDocuments
            .Include(d => d.Tenant).ThenInclude(t => t.Property)
            .FirstOrDefaultAsync(d => d.Id == documentId && d.Tenant.Property.UserId == userId);

        if (doc == null) return false;

        _storage.Delete(doc.FileUrl);
        _context.TenantDocuments.Remove(doc);
        await _context.SaveChangesAsync();

        return true;
    }

    private static DocumentDto MapToDto(TenantDocument d) => new()
    {
        Id = d.Id,
        OwnerId = d.TenantId,
        FileName = d.FileName,
        DocumentType = Enum.TryParse<DocumentType>(d.DocumentType, out var t) ? t : DocumentType.Other,
        FileUrl = d.FileUrl,
        FileSize = d.FileSize,
        UploadedAt = d.CreatedAt,
    };
}
