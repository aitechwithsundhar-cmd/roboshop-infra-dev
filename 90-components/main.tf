module "component" {
    for_each = var.components
    source = "git:://https://github.com/aitechwithsundhar-cmd/terraform-roboshop-component.git?ref=main"
    component = each.key
    rule_priority = each.value_priority
    
    }