// ==UserScript==
// @name fixGoogleJsActionsForVimium.user
// @description Remove "jsaction"s that produce "inert" Vimium link hints.
// @version 1.0.0
// @namespace https://github.com/ravindUwU/dotfiles
// @downloadURL https://raw.githubusercontent.com/ravindUwU/dotfiles/main/firefox/violentmonkey/fixGoogleJsActionsForVimium.user.js
// @homepageURL https://github.com/ravindUwU/dotfiles/blob/main/firefox/violentmonkey/fixGoogleJsActionsForVimium.user.js
// @match https://www.google.com/search*
// ==/UserScript==

/*
	Vimium provides link hints for "jsactions",
		https://github.com/angular/angular/blob/main/packages/core/primitives/event-dispatch/README.md
		https://github.com/philc/vimium/blob/3c4e6da46a6ebae93232ae6dddb65c293e97611a/content_scripts/link_hints.js#L1162-L1176

	Google search results seem to have non-click jsactions, so activating the corresponding link
	hint does nothing. For example, as of 2025-10-12, each result at
	https://www.google.com/search?q=huh&udm=14 shows 2 link hints: one adjacent to the logo, and the
	other adjacent to the title of the result. Only of of these hints navigates to the web page when
	activated.

	This script attempts to remove problematic jsactions.
*/

(() => {
	function remove() {
		for (const span of document.querySelectorAll('span[jsaction]')) {
			span.removeAttribute('jsaction');
		}
	}

	remove();
	setInterval(remove, 750);
})();

