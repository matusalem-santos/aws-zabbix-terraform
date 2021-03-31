# Recurso que executa o script "install.sh" que instala as dependencias na maquina
resource "null_resource" "install_dependencies" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = file("${path.module}/install.sh")
    
    # @TODO: Verificar alguma forma de passar um depends_on pra esse módulo
  }
}