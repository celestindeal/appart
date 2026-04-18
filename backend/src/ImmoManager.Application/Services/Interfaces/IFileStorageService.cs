using Microsoft.AspNetCore.Http;

namespace ImmoManager.Application.Services.Interfaces;

/// Gère le stockage physique des fichiers uploadés.
public interface IFileStorageService
{
    /// Sauvegarde un fichier dans le sous-dossier indiqué.
    /// Retourne l'URL publique relative (ex : "/uploads/tenants/xxx/yyy.pdf").
    Task<StoredFile> SaveAsync(IFormFile file, string subFolder);

    /// Supprime le fichier à l'URL relative donnée.
    void Delete(string fileUrl);
}

public record StoredFile(string FileUrl, long FileSize);
