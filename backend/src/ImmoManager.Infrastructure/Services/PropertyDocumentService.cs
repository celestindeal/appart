using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using ImmoManager.Application.DTOs.Documents;
using ImmoManager.Application.Services.Interfaces;
using ImmoManager.Domain.Entities;
using ImmoManager.Domain.Enums;
using ImmoManager.Infrastructure.Persistence;

namespace ImmoManager.Infrastructure.Services;

public class PropertyDocumentService : IPropertyDocumentService
{
    private readonly ImmoManagerDbContext _context;
    private readonly IFileStorageService _storage;

    public PropertyDocumentService(ImmoManagerDbContext context, IFileStorageService storage)
    {
        _context = context;
        _storage = storage;
    }

    public async Task<List<DocumentDto>> GetByPropertyAsync(Guid propertyId, Guid userId)
    {
        var docs = await _context.PropertyDocuments
            .Include(d => d.Property)
            .Where(d => d.PropertyId == propertyId && d.Property.UserId == userId)
            .OrderByDescending(d => d.CreatedAt)
            .ToListAsync();

        return docs.Select(MapToDto).ToList();
    }

    public async Task<DocumentDto> UploadAsync(Guid propertyId, IFormFile file, DocumentType type, Guid userId)
    {
        var property = await _context.Properties
            .FirstOrDefaultAsync(p => p.Id == propertyId && p.UserId == userId);

        if (property == null)
            throw new ArgumentException("Le bien n'existe pas.");

        var stored = await _storage.SaveAsync(file, $"properties/{propertyId}");

        var doc = new PropertyDocument
        {
            PropertyId = propertyId,
            DocumentName = file.FileName,
            DocumentType = type.ToString(),
            StorageUrl = stored.FileUrl,
            FileSize = stored.FileSize,
        };

        _context.PropertyDocuments.Add(doc);
        await _context.SaveChangesAsync();

        return MapToDto(doc);
    }

    public async Task<bool> DeleteAsync(Guid documentId, Guid userId)
    {
        var doc = await _context.PropertyDocuments
            .Include(d => d.Property)
            .FirstOrDefaultAsync(d => d.Id == documentId && d.Property.UserId == userId);

        if (doc == null) return false;

        _storage.Delete(doc.StorageUrl);
        _context.PropertyDocuments.Remove(doc);
        await _context.SaveChangesAsync();

        return true;
    }

    private static DocumentDto MapToDto(PropertyDocument d) => new()
    {
        Id = d.Id,
        OwnerId = d.PropertyId,
        FileName = d.DocumentName,
        DocumentType = Enum.TryParse<DocumentType>(d.DocumentType, out var t) ? t : DocumentType.Other,
        FileUrl = d.StorageUrl,
        FileSize = d.FileSize,
        UploadedAt = d.CreatedAt,
    };
}
