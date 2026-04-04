using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ImmoManager.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddApartmentCountToProperty : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ApartmentCount",
                table: "Properties",
                type: "INTEGER",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ApartmentCount",
                table: "Properties");
        }
    }
}
