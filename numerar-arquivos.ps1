function Show-Menu {
    Clear-Host
    Write-Host "===== MENU =====" -ForegroundColor Cyan
    Write-Host "1. Definir o caminho da pasta"
    Write-Host "2. Renomear arquivos na pasta"
    Write-Host "3. Sair"
    Write-Host "================"
}

function Set-FolderPath {
    # Solicitar o caminho da pasta
    $global:folderPath = Read-Host "Digite o caminho completo da pasta com os arquivos"

    # Verificar se o diretório existe
    if (Test-Path -Path $folderPath) {
        Write-Host "Caminho salvo com sucesso: $folderPath" -ForegroundColor Green
    } else {
        Write-Host "Erro: O caminho especificado não existe. Tente novamente." -ForegroundColor Red
        $global:folderPath = ""
    }
}

function Rename-Files {
    # Verificar se o caminho foi definido
    if ([string]::IsNullOrWhiteSpace($folderPath)) {
        Write-Host "Erro: O caminho da pasta não foi definido. Escolha a opção 1 no menu para definir." -ForegroundColor Yellow
        return
    }

    # Obter todos os arquivos na pasta
    $files = Get-ChildItem -Path $folderPath -File

    # Verificar se há arquivos na pasta
    if ($files.Count -eq 0) {
        Write-Host "Nenhum arquivo encontrado no diretório especificado." -ForegroundColor Yellow
        return
    }

    # Contador para numerar os arquivos
    $counter = 1

    # Renomear os arquivos
    foreach ($file in $files) {
        # Remover caracteres inválidos do nome original
        $cleanName = ($file.BaseName -replace '[\\/:*?"<>|]', '_')

        # Criar o novo nome
        $newName = "{0:D3} - $cleanName{1}" -f $counter, $file.Extension

        # Definir o novo caminho completo
        $newPath = Join-Path -Path $folderPath -ChildPath $newName

        # Renomear o arquivo com LiteralPath para lidar com caracteres especiais
        try {
            Rename-Item -LiteralPath $file.FullName -NewName $newPath
            Write-Host "Renomeado: $($file.Name) -> $newName" -ForegroundColor Green
        } catch {
            Write-Host "Erro ao renomear: $($file.Name). $_" -ForegroundColor Red
        }

        # Incrementar o contador
        $counter++
    }

    Write-Host "Processo concluído! $($counter - 1) arquivos foram renomeados." -ForegroundColor Cyan
}

# Loop principal do menu
do {
    Show-Menu
    $choice = Read-Host "Escolha uma opção"

    switch ($choice) {
        "1" {
            Set-FolderPath
            Start-Sleep -Seconds 2
        }
        "2" {
            Rename-Files
            Start-Sleep -Seconds 2
        }
        "3" {
            Write-Host "Saindo... Até mais!" -ForegroundColor Yellow
            break
        }
        default {
            Write-Host "Opção inválida. Tente novamente." -ForegroundColor Red
        }
    }
} while ($choice -ne "3")
