# Recurso que provisiona o Hosted Zone no Route53
resource "aws_route53_zone" "private" {
  name = var.hosted_name

  vpc {
    vpc_id = var.vpc_id
  }
}

# Recurso que provisiona o Record dentro do Hosted Zone criado a cima
# apontando para o IP privado do Zabbix Sever
resource "aws_route53_record" "zabbix" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "zabbix.${var.hosted_name}"
  type    = "A"
  ttl     = "300"
  records = [var.private_ip]
}