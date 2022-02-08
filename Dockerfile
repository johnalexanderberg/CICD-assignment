FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY ["aspnetdocker.csproj", "./"]
RUN dotnet restore "aspnetdocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aspnetdocker.csproj" -c Release -o /app/build
ENTRYPOINT ["dotnet", "run"]

FROM build AS publish
RUN dotnet publish "aspnetdocker.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspnetdocker.dll"]
