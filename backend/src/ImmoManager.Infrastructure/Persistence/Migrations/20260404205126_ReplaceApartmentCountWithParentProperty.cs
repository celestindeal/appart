using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ImmoManager.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ReplaceApartmentCountWithParentProperty : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ApartmentCount",
                table: "Properties");

            migrationBuilder.AddColumn<Guid>(
                name: "ParentPropertyId",
                table: "Properties",
                type: "TEXT",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Properties_ParentPropertyId",
                table: "Properties",
                column: "ParentPropertyId");

            migrationBuilder.AddForeignKey(
                name: "FK_Properties_Properties_ParentPropertyId",
                table: "Properties",
                column: "ParentPropertyId",
                principalTable: "Properties",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Properties_Properties_ParentPropertyId",
                table: "Properties");

            migrationBuilder.DropIndex(
                name: "IX_Properties_ParentPropertyId",
                table: "Properties");

            migrationBuilder.DropColumn(
                name: "ParentPropertyId",
                table: "Properties");

            migrationBuilder.AddColumn<int>(
                name: "ApartmentCount",
                table: "Properties",
                type: "INTEGER",
                nullable: true);
        }
    }
}
