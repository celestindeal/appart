using System.Linq.Expressions;
using ImmoManager.Domain.Common;

namespace ImmoManager.Domain.Repositories;

public interface IRepository<T> where T : BaseEntity
{
    Task<T?> GetByIdAsync(Guid id);
    Task<IReadOnlyList<T>> GetAllAsync();
    Task<T> AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(T entity);
    Task<IReadOnlyList<T>> FindAsync(Expression<Func<T, bool>> predicate);
}
