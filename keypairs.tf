resource "aws_key_pair" "anksagarkey" {
  key_name   = "anksagarkey"
  public_key = file(var.PUB_KEY_PATH)
}