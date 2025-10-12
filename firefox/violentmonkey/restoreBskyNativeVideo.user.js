// ==UserScript==
// @name restoreBskyNativeVideo
// @description Replace Bluesky's custom video player with the browser-native video player.
// @version 1.0.0
// @namespace https://github.com/ravindUwU/dotfiles
// @downloadURL https://raw.githubusercontent.com/ravindUwU/dotfiles/main/firefox/violentmonkey/restoreBskyNativeVideo.user.js
// @homepageURL https://github.com/ravindUwU/dotfiles/blob/main/firefox/violentmonkey/restoreBskyNativeVideo.user.js
// @match https://bsky.app/*
// ==/UserScript==


/*
	The DOM of/adjacent to the Bluesky custom video player (which lacks playback speed controls) is,
		<div $container>
			<figure $figure>
				<video></video>
				<figcaption>Alt text</figcaption>
			</figure>

			<div>
				<!-- Overlay with custom video player controls -->
			</div>
		</div>

	This script, replaces the $container with the $figure, enables native controls, and unmutes the
	video.
*/

setInterval(() => {
	for (const video of document.querySelectorAll('video:not([data-dotfiles-restore-native-video])')) {
		const figure = video.parentElement;
		if (!(figure instanceof HTMLElement && figure.tagName === 'FIGURE')) {
			return;
		}

		const container = figure.parentElement;
		if (!(container instanceof HTMLDivElement)) {
			return;
		}

		container.replaceWith(figure);

		video.controls = true;
		video.muted = false;
		video.volume = 0.5;

		video.dataset.dotfilesRestoreNativeVideo = '';
	}
}, 750);
