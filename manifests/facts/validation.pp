# Define: puppet::facts::validation
#
# Validation values of parametr custom_facts from class: puppet::facts
#
define puppet::facts::validation {
  unless is_string($title) or is_array($title) or is_hash($title) {
    warning("Values of custom_facts must be Sring or Array or Hash!")
  }
}
