// ==UserScript==
// @name redirectYouTubeShorts
// @description Redirect youtube.com/shorts to youtube.com/watch
// @version 1.0.0
// @namespace https://github.com/ravindUwU/dotfiles
// @downloadURL https://raw.githubusercontent.com/ravindUwU/dotfiles/main/firefox/violentmonkey/redirectYouTubeShorts.user.js
// @homepageURL https://github.com/ravindUwU/dotfiles/blob/main/firefox/violentmonkey/redirectYouTubeShorts.user.js
// @match https://www.youtube.com/*
// ==/UserScript==

// Kinda like https://greasyfork.org/en/scripts/439993 but doesn't use a MutationObserver on the
// <body> and all of its children, which sounds like a lot of unnecessary checks, and YouTube is a
// very "heavy" web app as-is. The 400ms interval this one uses should be "lighter".

// Kinda like https://greasyfork.org/en/scripts/468363 but doesn't rely on YouTube-specific events,
// which Google will probably break/remove at some point.

(() => {
	const SHORTS = 'youtube.com/shorts/';
	const TROUSERS = 'youtube.com/watch?v=';

	let lastReplaced = null;

	function tryReplace() {
		const href = window.location.href;

		if (lastReplaced !== href && href.includes(SHORTS)) {
			lastReplaced = href;
			window.location.replace(href.replace(SHORTS, TROUSERS));
		}
	}

	tryReplace();
	setInterval(tryReplace, 400);
})();
