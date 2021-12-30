import accessibleAutocomplete from "accessible-autocomplete";

export const initCachedProvidersAutocomplete = ({inputIds}) => {
  const autocompleteId = 'provider-autocomplete'

  inputIds.forEach((inputId) => {
    try {
      const selectElement = document.getElementById(inputId)

      if (!selectElement) return

      // Replace "Select a ..." with empty string
      selectElement.querySelector("[value='']").innerHTML = ''

      accessibleAutocomplete.enhanceSelectElement({
        selectElement,
        autoselect: false,
        confirmOnBlur: false,
        showNoOptionsFound: true,
        showAllValues: false,
      })
    } catch (err) {
      console.error(`Could not enhance ${autocompleteId}`, err)
    }
  })
}
