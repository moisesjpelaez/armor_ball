package arm.autoload;

#if (kha_html5 || kha_debug_html5)
import arm.autoload.GameEvents;
import js.Syntax;
import kha.graphics2.Graphics;
import kha.Color;
import kha.System;

class Transitions extends iron.Trait {
	// Must be an instance since this is a Trait
	public static final inst: Transitions = new Transitions();
	var loadingElementCode: String = "";

	function new() {
		super();
	}

	public function init() {
		GameEvents.sceneLoaded.connect(onSceneLoaded);
		GameEvents.sceneUnloaded.connect(onSceneUnloaded);

		notifyOnRender2D(render2D);

		Syntax.code("const loaderStyleString = `
			#loader {
				position: absolute;
				bottom: 32px;
				right: 32px;
				width: 50px;
				padding: 8px;
				aspect-ratio: 1;
				border-radius: 50%;
				background: #ffffff;
				--_m:
				conic-gradient(#0000 10%,#000),
				linear-gradient(#000 0 0) content-box;
				-webkit-mask: var(--_m);
						mask: var(--_m);
				-webkit-mask-composite: source-out;
						mask-composite: subtract;
				animation: l3 1s infinite linear;
			}
			@keyframes l3 {to{transform: rotate(1turn)}}`;
		");
		Syntax.code("const loaderStyleElement = document.createElement('style');");
		Syntax.code("loaderStyleElement.textContent = loaderStyleString;");
		Syntax.code("document.head.appendChild(loaderStyleElement);");

		addLoader();
	}

	function onSceneLoaded() {
		removeRender2D(render2D);
		removeLoader();
	}

	function onSceneUnloaded() {
		notifyOnRender2D(render2D);
		addLoader();
	}

	public function render2D(g2: Graphics) {
		g2.end();
		g2.color = Color.Black;
		g2.fillRect(0, 0, System.windowWidth(), System.windowHeight());
		g2.begin(false);
	}

	function addLoader() {
		Syntax.code("const loaderElement = document.createElement('div');");
		Syntax.code("loaderElement.id = 'loader';");
		Syntax.code("document.body.appendChild(loaderElement);");
	}

	function removeLoader() {
		Syntax.code("document.getElementById('loader').remove();");
	}
}
#end
