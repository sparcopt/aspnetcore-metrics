FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY src/Presentation.WebAPI/*.csproj ./src/Presentation.WebAPI/
RUN dotnet restore

# copy everything else and build app
COPY src/Presentation.WebAPI/. ./src/Presentation.WebAPI/
WORKDIR /app/src/Presentation.WebAPI
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://*:5000 \
    ASPNETCORE_ENVIRONMENT=Development
EXPOSE 5000
COPY --from=build /app/src/Presentation.WebAPI/out ./
ENTRYPOINT ["dotnet", "Presentation.WebAPI.dll"]
