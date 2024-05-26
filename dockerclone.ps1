param(
    [Parameter(Mandatory=$true)]
    [string]$OriginalContainer,

    [string]$NewImage = "$OriginalContainer`_image",
    
    [string]$NewContainer = "$OriginalContainer`_clone"
)

function Clone-DockerContainer {
    param (
        [string]$OriginalContainer,
        [string]$NewImage,
        [string]$NewContainer
    )

    Write-Output "Clonando o contêiner:"
    Write-Output "Contêiner original: $OriginalContainer"
    Write-Output "Nova imagem: $NewImage"
    Write-Output "Novo contêiner: $NewContainer"

    # Etapa 1: Criar uma imagem a partir do contêiner em execução
    Write-Output "Criando uma imagem a partir do contêiner '$OriginalContainer'..."
    docker commit $OriginalContainer $NewImage

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Erro ao criar a imagem."
        exit 1
    }

    # Etapa 2: Criar um novo contêiner a partir da nova imagem
    Write-Output "Criando um novo contêiner '$NewContainer' a partir da imagem '$NewImage'..."
    docker run -d --name $NewContainer $NewImage

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Erro ao criar o novo contêiner."
        exit 1
    }

    Write-Output "Contêiner '$NewContainer' criado com sucesso a partir da imagem '$NewImage'."
}

Clone-DockerContainer -OriginalContainer $OriginalContainer -NewImage $NewImage -NewContainer $NewContainer
