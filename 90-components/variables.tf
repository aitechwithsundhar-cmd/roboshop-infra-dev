variable "components" {
  default = {
    # backend component are attaching to backend ALB 
    catalogue = {
      rule_priority = 10
    }
    user = {
      rule_priority = 20
    }
    cart = {
      rule_priority = 30
    }
    shipping = {
      rule_priority = 40
    }
    payment = {
      rule_priority = 50
    }
    # this is attaching to frontend ALB, there is only component there
    frontend = {
      rule_priority = 10
    }
  }
}