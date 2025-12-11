// ==UserScript==
// @name fixGitHubChangelogColorMode
// @description Make the GitHub changelog adapt to the browser colour scheme.
// @version 1.0.0
// @namespace https://github.com/ravindUwU/dotfiles
// @downloadURL https://raw.githubusercontent.com/ravindUwU/dotfiles/main/firefox/violentmonkey/fixGitHubChangelogColorMode.user.js
// @homepageURL https://github.com/ravindUwU/dotfiles/blob/main/firefox/violentmonkey/fixGitHubChangelogColorMode.user.js
// @match  https://github.blog/changelog/*
// ==/UserScript==

/*
	The GitHub changelog is stuck in dark mode. Seeing the [data-color-mode="dark"] everywhere, I
	think they're forcing dark mode? Do they think "all devs use dark mode" and "dark mode cool" or
	whatever, and that this is appropriate because their target audience is developers?

	Regardless, this is *not* cool. When there's a lot of ambient light, dark mode is hard to read
	and stresses your eyes out and requires that you bump up the brightness on your screen; and
	vice-versa. Do the decent thing and honour your users' light/dark mode preference, GitHub.

	https://github.com/orgs/community/discussions/179127
*/

(() => {
	if (document.body.dataset.dotfilesFixedColorMode === 'yeppers') return;
	document.body.dataset.dotfilesFixedColorMode = 'yeppers';

	const mql = window.matchMedia('(prefers-color-scheme: light)');

	function fix() {
		if (mql.matches) {
			for (const el of document.querySelectorAll('[data-color-mode="dark"]')) {
				if (el instanceof HTMLElement) {
					el.dataset.colorMode = 'light';
				}
			}
		} else {
			for (const el of document.querySelectorAll('[data-color-mode="light"]')) {
				if (el instanceof HTMLElement) {
					el.dataset.colorMode = 'dark';
				}
			}
		}
	}

	fix();
	mql.addEventListener('change', fix);
})();
