data "azurerm_shared_image_versions" "images" {
  for_each = local.gallery_image_definitions

  gallery_name        = var.gallery_name
  image_name          = each.value
  resource_group_name = var.gallery_resource_group_name
  tags_filter = var.image_tag_filter
}