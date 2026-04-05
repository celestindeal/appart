using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ImmoManager.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddPropertyEventsRemoveMonthlyRent : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MonthlyRent",
                table: "Properties");

            migrationBuilder.CreateTable(
                name: "PropertyEvents",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    PropertyId = table.Column<Guid>(type: "TEXT", nullable: false),
                    UserId = table.Column<Guid>(type: "TEXT", nullable: false),
                    EventType = table.Column<string>(type: "TEXT", maxLength: 50, nullable: false),
                    Title = table.Column<string>(type: "TEXT", maxLength: 200, nullable: false),
                    Description = table.Column<string>(type: "TEXT", nullable: true),
                    StartDate = table.Column<DateTime>(type: "TEXT", nullable: false),
                    EndDate = table.Column<DateTime>(type: "TEXT", nullable: true),
                    MonthlyRent = table.Column<decimal>(type: "TEXT", nullable: true),
                    DepositAmount = table.Column<decimal>(type: "TEXT", nullable: true),
                    Cost = table.Column<decimal>(type: "TEXT", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PropertyEvents", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PropertyEvents_Properties_PropertyId",
                        column: x => x.PropertyId,
                        principalTable: "Properties",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PropertyEvents_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_PropertyEvents_PropertyId",
                table: "PropertyEvents",
                column: "PropertyId");

            migrationBuilder.CreateIndex(
                name: "IX_PropertyEvents_UserId",
                table: "PropertyEvents",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PropertyEvents");

            migrationBuilder.AddColumn<decimal>(
                name: "MonthlyRent",
                table: "Properties",
                type: "TEXT",
                nullable: true);
        }
    }
}
