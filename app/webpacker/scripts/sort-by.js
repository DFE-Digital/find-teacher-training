const initSortBy = ({sortbyFormId, sortbyFormSelectClass}) => {
  const sortby_form = document.getElementById(sortbyFormId);
  if (!sortby_form) return;

  const sortByFormSelect = sortby_form.getElementsByClassName(sortbyFormSelectClass)[0];

  try {
    if(sortByFormSelect) {
      sortByFormSelect.onchange = () => {
        sortby_form.submit();
      }
    }
  } catch(err) {
    console.error(`Failed to initialise ${sortbyFormSelectClass} sort by:`, err);
  }
};

export default initSortBy;
