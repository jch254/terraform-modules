output "table_name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.main.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.main.arn
}

output "table_id" {
  description = "ID of the DynamoDB table."
  value       = aws_dynamodb_table.main.id
}

output "table_hash_key" {
  description = "Hash key attribute name."
  value       = aws_dynamodb_table.main.hash_key
}

output "table_range_key" {
  description = "Range key attribute name."
  value       = aws_dynamodb_table.main.range_key
}