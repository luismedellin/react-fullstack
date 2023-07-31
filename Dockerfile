# Etapa 1: Construir la aplicación de React con Vite
FROM node:14 AS react-build
WORKDIR /app/ClientApp
COPY ClientApp/package.json ClientApp/package-lock.json ./
RUN npm install
COPY ClientApp ./
RUN npm run build

# Etapa 2: Construir y publicar la Web API de .NET
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS dotnet-build
WORKDIR /app
COPY react-fullstack.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet publish -c Release -o publish

# Etapa 3: Ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=dotnet-build /app/publish ./
COPY --from=react-build /app/ClientApp/dist ./ClientApp/dist
ENTRYPOINT ["dotnet", "react-fullstack.dll"]