const initSortBy = ({sortby_form_id, sortby_form_select_class}) => {
  const sortby_form = document.getElementById(sortby_form_id);
  if (!sortby_form) return;

  const sort_by_form_select = sortby_form.getElementsByClassName(sortby_form_select_class)[0];


  try {
    if(sort_by_form_select) {
      sort_by_form_select.onchange = () => {
        console.log("asasd")
        sortby_form.submit();}
    }
  } catch(err) {
    console.error(`Failed to initialise ${sortby_form_select_id} sort by:`, err);
  }
};

export default initSortBy;





