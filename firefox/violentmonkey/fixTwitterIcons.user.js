// ==UserScript==
// @name fixTwitterIcons
// @description Fix Twitter icons
// @version 1.0.0
// @namespace https://github.com/ravindUwU/dotfiles
// @downloadURL https://raw.githubusercontent.com/ravindUwU/dotfiles/main/firefox/violentmonkey/fixTwitterIcons.user.js
// @homepageURL https://github.com/ravindUwU/dotfiles/blob/main/firefox/violentmonkey/fixTwitterIcons.user.js
// @match https://twitter.com/*
// @match https://x.com/*
// ==/UserScript==

(() => {
	// Twitter logo SVG from Wikimedia Commons exported into a 32x32px PNG.
	// https://commons.wikimedia.org/wiki/File:Logo_of_Twitter.svg
	const birb = 'data:image/png;base64,' + 'iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABgGlDQ1BzUkdCIElFQzYxOTY2LTIuMQAAKJF1kbtLA0EQh78kihKVCFpYWBwSraLECEEbiwRfoBZJBKM2yZmHkMdxlyDBVrAVFEQbX4X+BdoK1oKgKIJYWyvaaDjnEiFBzAy7++1vZ4bdWbBHMmrWaPJCNlfQQ1MBZTG6pLS84qRJ3IYvphraXHgyQkP7fJA4sbtBq1bjuH+tbTVhqGBrFR5XNb0gPC08u17QLN4V7lbTsVXhc2GPLhcUvrf0eJVfLU5V+dtiPRIKgr1TWEnVcbyO1bSeFZaX485miurvfayXtCdyC2FZ+2T0YhBiigAKM0wQxM8wYzL7GcTHkOxokO+t5M+Tl1xVZo0SOmukSFPAI2pRqidkTYqeEM9Qsvr/t69GcsRXrd4egOYX03zvh5YdKG+b5texaZZPwPEMV7lafv4IRj9E365p7kNwbcLFdU2L78HlFvQ8aTE9VpEcMuzJJLydQUcUum7BuVzt2e85p48Q2ZCvuoH9AxiQeNfKDzAAZ821CGSUAAAACXBIWXMAAAsTAAALEwEAmpwYAAACgUlEQVRYhe3WT4hWVRzG8c87jSNBDockcNEtAoO0VUkhgosWLhJ0ZxCBJHjIhUy1kCDFiIhsI2i18SIuJBSSiMKilTXVqj8kLrS/IEetwODGMKERo4t7b1xn3nfe9zrzVgsfeDmc333Oeb6ce+55D7f0H6uzWBNledHBE9iCVViOr/AZ3kwxTDe8S7AOk51GcQcOpRhmbiL8XuTY0MPyPZ7CNLZhK95IMbzaqSa4B+dxBNvbQGR5MYIvsLaPdQYjDaCHUwzTdWFT1W7D4SwvbhsUANsHCNcI/xp78VKWF5vr4ljD+DQms7xY1W/GLC/G8frgrOAhHMff+KAGmJ5lWodvs7zYk+XFmN5agdASYAQHsDvFcK0G+LSLcQyv4IcsL17O8uK+Lp7bW4bDKTyfYrhG4zPM8uIkNg4w+BTO4pzyU/ukJcDRFMPWujPaeLALj+CueQY/Vv0Wot+anRHI8uJZTOAg/lxgQD/92uzUK/AHnhlycK0LzU69CT9XHhT/hibnAKQYflQepcPW6RTDL3MAKu3B6SEDfDy78A9AiuEy1uPdIYXP4FBPgEpLcQKv4fIiAxxPMfw0uzg6qz+lPNuzRQ6Hfd2KN6xAiuEqXhhC+P4Uw5m+ABXEMexcxPBv8GKvh3MAKoi3sAYf4q8FhE/hyWplu6rvnTDLi5V4G4+2DP8dj6cYvpzP1BMgy4s7sVv5Oua7E3TTRWxIMZztZ+xkeXEHrip3/oNYXbWbtL9swPvYmWJIg5hHq5AJ5Z/R+E0E1voZEymGk20GNS8k44h4DncPOP6KcqO+g/dSDFfahN8A0ABZggdwP1Y22mW4pHy/l/AdPkoxTLUNvaX/la4D322nkmAKV2kAAAAASUVORK5CYII=';

	function tryReplace() {

		// Replace favicon if it isn't already.
		const shortcutIcon = document.querySelector('head > link[rel="shortcut icon"]');
		if (shortcutIcon !== null && shortcutIcon.href != birb) {
			shortcutIcon.href = birb;
		}

		// Replace header logo. It's 27px on its long edge before replacement, so our birb :3 should
		// do just fine.
		const headerLogo = document.querySelector('header h1[role="heading"] a[href="/home"][aria-label="X"] svg');
		if (headerLogo !== null) {
			const img = document.createElement('img');
			img.width = img.height = 27;
			img.src = birb;

			headerLogo.parentElement.replaceChildren(img);
		}
	}

	tryReplace();
	setInterval(tryReplace, 400);
})();
