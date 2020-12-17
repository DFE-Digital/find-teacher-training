const refreshStartPage = () => {
    if (window.location.pathname === '/' && performance.navigation.type === 2) {
        location.reload(true);
    }
}
export default refreshStartPage;
