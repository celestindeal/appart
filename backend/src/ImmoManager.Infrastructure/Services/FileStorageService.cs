using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using ImmoManager.Application.Services.Interfaces;

namespace ImmoManager.Infrastructure.Services;

public class FileStorageService : IFileStorageService
{
    private readonly IWebHostEnvironment _env;
    private const string PublicRoot = "uploads";

    public FileStorageService(IWebHostEnvironment env)
    {
        _env = env;
    }

    public async Task<StoredFile> SaveAsync(IFormFile file, string subFolder)
    {
        if (file.Length == 0)
            throw new ArgumentException("Fichier vide.");

        var rootPath = Path.Combine(_env.ContentRootPath, "wwwroot", PublicRoot, subFolder);
        Directory.CreateDirectory(rootPath);

        var safeName = SanitizeFileName(Path.GetFileName(file.FileName));
        var uniqueName = $"{Guid.NewGuid():N}_{safeName}";
        var absolutePath = Path.Combine(rootPath, uniqueName);

        await using var stream = File.Create(absolutePath);
        await file.CopyToAsync(stream);

        var relativeUrl = $"/{PublicRoot}/{subFolder.Replace('\\', '/')}/{uniqueName}";
        return new StoredFile(relativeUrl, file.Length);
    }

    public void Delete(string fileUrl)
    {
        if (string.IsNullOrWhiteSpace(fileUrl)) return;

        var relative = fileUrl.TrimStart('/').Replace('/', Path.DirectorySeparatorChar);
        var absolute = Path.Combine(_env.ContentRootPath, "wwwroot", relative);

        if (File.Exists(absolute))
        {
            try { File.Delete(absolute); } catch { /* best effort */ }
        }
    }

    private static string SanitizeFileName(string name)
    {
        var invalid = Path.GetInvalidFileNameChars();
        var clean = string.Concat(name.Select(c => invalid.Contains(c) ? '_' : c));
        return clean.Length > 120 ? clean[..120] : clean;
    }
}
