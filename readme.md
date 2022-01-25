<div id="top"></div>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

## Mellon.ConfigServer

[![CI](https://github.com/1bberto/Mellon.ConfigServer/actions/workflows/buildAndPush.yml/badge.svg?branch=main)](https://github.com/1bberto/Mellon.ConfigServer/actions/workflows/buildAndPush.yml)


Why Mellon, mellon is the Sindarin (and Noldorin) word for "friend", yes I'm a big fan of LoR, so let's be friends?

<!-- ABOUT THE PROJECT -->
## About The Project

The main idea of this project is to create a instance of "Spring Cloud Config" using "Azure Key Vault" and showing how to use it on net 6 applications.

Here's why:
* Spring Cloud Config is a well know tool for externalized configuration in distributed systems.
* Azure Key Vault is excellent to store secrets and there a lot of companies that uses azure as their cloud provider
* net 6 is the most advanced and fast framework to develop applications using C#
* It's fun! 🚀🎉

### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* [Spring Cloud Config](https://cloud.spring.io/spring-cloud-config/reference/html/)
* [Gradle](https://gradle.org/)
* [Spring Cloud Azure KeyVault](https://github.com/srempfer/spring-cloud-config-azure-keyvault)
* [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/)
* [net6](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)
* [steeltoe](https://docs.steeltoe.io/api/v3/configuration/)

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

This is an example of how to list things you need to use the software and how to install them, I used *WSL* - Debian to build and test locally the config-server, but if you want to jump this step no worries.

* Unzip 
```sh
sudo apt-get install unzip
```
* Java
```sh
sudo apt-get install openjdk-8-jre
 ```
* Gradle - fallow [How to Install Gradle on Ubuntu](https://linuxize.com/post/how-to-install-gradle-on-ubuntu-18-04/), but instead of installing the version 5.0 change it to 7.3.3.

* Docker (if you want just to run it using docker)
  
#### Running it using linux (after you fallowed the steps on Prerequisites: 
```sh
gradle clean build
export GIT_URI = https://github.com/1bberto/Mellon.ConfigServer.Configs
export GIT_DEFAULT_BRANCH = main
export SPRING_PROFILES_ACTIVE = Development
cd build/libs
java -jar Mellon.ConfigServer-1.0.0.jar
```
the default port is :8888

#### Running it on docker: 

Use the file docker-compose.yaml which has the fallowing content 

```yaml
version: "3.4"
services:
  config-server:
    container_name: config-server
    image: 1berto/mellon.configserver
    environment:      
      KEYVAULT_URI: [] <-- AZURE KEY VAULT URI
      KEYVAULT_CLIENT_ID: [] <-- AZURE CLIENT ID
      KEYVAULT_CLIENT_SECRET: [] <-- AZURE CLIENT SECRET
      AZ_TENANT_ID: [] <-- AZURE CLIENT TENANT ID
      GIT_URI: https://github.com/1bberto/Mellon.ConfigServer.Configs <- you can add your repository here
      GIT_DEFAULT_BRANCH: main <- the default value is master, but you can add whichever branch you want here to be used as default
      GIT_USERNAME: [] <- if your repository is private add the username here
      GIT_PASSWORD: [] <- if your repository is private add the user token/password here
      SPRING_PROFILES_ACTIVE: Development <- here you can set the default spring profile active
    ports:
      - "8888:8888"
```

<!-- USAGE EXAMPLES -->
## Usage

Keep the Config Server running, using docker-compose for example, the api needs this to be up in order to get the configurations 🤓

There is an WebApi called Sample inside the folder /tests

#### Running the WebApi
```sh
dotnet run Sample.csproj
```

The application will be exposed on the endpoint https://localhost:7180

When you access this endpoint you will see something like this

![image](https://user-images.githubusercontent.com/3129978/150921808-2570b7ae-cc6b-4bf7-9db6-56ca7499dfa2.png)

on the file application.
```json
"Spring": {
  "Application": {
    "Name": "api"
  },
  "Cloud": {
    "Config": {
      "Uri": "http://localhost:8888",
      "FailFast": true 
    }
  }
}  
```

* *Spring.Application.Name* = application's name needs to be the same as stored on the repository where the config is stored, ill get there in a minute don't worry
* *Spring.Cloud.Config.Uri* = this is the spring cloud url
* *Spring.Cloud.Config.FailFast* = if set to true the application will not start up if the config server is not found

### Storing the configuration and Settings

As you might have realised the configurations and settings are inside another repository [Config-Repository](https://github.com/1bberto/Mellon.ConfigServer.Configs)

Within this config you will find the fallowing structure

![image](https://user-images.githubusercontent.com/3129978/150923013-a1133d9a-ee45-4a21-9aab-0bba5fb4e0c1.png)

the spring cloud config works using layers, and this is the hierarchy:
* first it will loads the configuration on the file *application.yml*
* then [Spring.Application.Name].yml if exists
* then [Spring.Application.Name]-[profile].yml 
 * profile in this case is set as "Development", you can change it on the file /tests/Properties/launchSettings.json changing the `ASPNETCORE_ENVIRONMENT`

if we change the `ASPNETCORE_ENVIRONMENT` to *Production* and run the api the new response on the *https://localhost:7180* endpoint will be 

![image](https://user-images.githubusercontent.com/3129978/150924486-01916077-7a64-4b31-b6b6-e58fd8d108f6.png)

### Using Azure Key Vault 

In order to access Azure Key Vault you will need to setup the service on azure portal [Quickstart: Create a key vault using the Azure portal](https://docs.microsoft.com/en-us/azure/key-vault/general/quick-create-portal) after that you will need to setup the programatically access in order to get the credendials: *KEYVAULT_CLIENT_ID* and *KEYVAULT_CLIENT_SECRET* [Accessing Azure Key Vault Secret through Azure Key Vault](https://anoopt.medium.com/accessing-azure-key-vault-secret-through-azure-key-vault-rest-api-using-an-azure-ad-app-4d837fed747), and dont forget to get the *AZ_TENANT_ID* [How to find your Azure Active Directory tenant ID](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-how-to-find-tenant)

After that all set you only need to reference you keyvault key to your config file

Creating key
![image](https://user-images.githubusercontent.com/3129978/150926104-495619d2-5380-46c1-b4b3-bc7293069111.png)

now you only need to reference this key on your config file
```yaml
super-secret-key: "{keyvault}secret-key"
```
to reference a key from the key vault you need to use the suffix *{keyvault}* + the secret name

by defaul the config server refresh the values from the Key Vault after 30 minutes, to speed up this process you can just restart the config server

restart your api aswell once the settings are only loaded when the application is starting up

and then BOOM 💣

![image](https://user-images.githubusercontent.com/3129978/150927445-8393d5c8-0b38-4e15-b64e-c27286596f3d.png)

<!-- ROADMAP -->
## Roadmap

- Ran out of Ideas 🤣, feel free to add one

See the [open issues](https://github.com/1bberto/Mellon.ConfigServer/issues) for a full list of proposed features (and known issues).

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- CONTACT -->
## Contact

Humberto Rodrigues - [@1bbertp](https://instagram.com/1bberto) - humberto_henrique1@live.com

Project Link: [https://github.com/1bberto/Mellon.ConfigServer](https://github.com/1bberto/Mellon.ConfigServer)

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Spring Cloud Config](https://cloud.spring.io/spring-cloud-config/reference/html/)
* [Gradle](https://gradle.org/)
* [Spring Cloud Azure KeyVault](https://github.com/srempfer/spring-cloud-config-azure-keyvault)
* [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/1bberto/Mellon.ConfigServer.svg?style=for-the-badge
[contributors-url]: https://github.com/1bberto/Mellon.ConfigServer/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/1bberto/Mellon.ConfigServer.svg?style=for-the-badge
[forks-url]: https://github.com/1bberto/Mellon.ConfigServer/network/members
[stars-shield]: https://img.shields.io/github/stars/1bberto/Mellon.ConfigServer.svg?style=for-the-badge
[stars-url]: https://github.com/1bberto/Mellon.ConfigServer/stargazers
[issues-shield]: https://img.shields.io/github/issues/1bberto/Mellon.ConfigServer.svg?style=for-the-badge
[issues-url]: https://github.com/1bberto/Mellon.ConfigServer/issues
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/humbberto
