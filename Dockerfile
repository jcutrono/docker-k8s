FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY uf-osc-webapi.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build-env /app/out .
EXPOSE 80
ENTRYPOINT ["dotnet", "uf-osc-webapi.dll"]