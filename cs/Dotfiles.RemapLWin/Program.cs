namespace Dotfiles.RemapLWin;

using SharpHook;
using SharpHook.Native;
using System.Diagnostics;
using System.Linq;

public class Program
{
	public static void Main()
	{
		ReplaceOtherInstances();
		Remap();
	}

	private static void ReplaceOtherInstances()
	{
		var current = Process.GetCurrentProcess();
		Debug.WriteLine($"Started {current.ProcessName}#{current.Id}");

		foreach (var p in Process.GetProcessesByName(current.ProcessName).Where((p) => p.Id != current.Id))
		{
			Debug.WriteLine($"Replaced {current.ProcessName}#{p.Id}");
			p.Kill();
		}
	}

	enum KeyMotion
	{
		Press,
		Release,
	}

	private static void Remap()
	{
		using var hook = new SimpleGlobalHook(GlobalHookType.Keyboard);
		var sim = new EventSimulator();

		(KeyMotion, KeyCode)? prevEvent = null;

		void Handle(KeyMotion type, KeyboardHookEventArgs e)
		{
			// Skip simulated events
			if (e.IsEventSimulated)
			{
				return;
			}

			var thisEvent = (type, e.Data.KeyCode);

			// Match LWin press + release
			if (
				prevEvent is (KeyMotion.Press, KeyCode.VcLeftMeta)
				&& thisEvent is (KeyMotion.Release, KeyCode.VcLeftMeta)
			)
			{
				// Suppress LWin release
				e.SuppressEvent = true;

				// Simulate the rest of LWin+Space
				sim.SimulateKeyPress(KeyCode.VcSpace);
				sim.SimulateKeyRelease(KeyCode.VcSpace);
				sim.SimulateKeyRelease(KeyCode.VcLeftMeta);
			}

			prevEvent = thisEvent;
		}

		hook.KeyPressed += (sender, e) => Handle(KeyMotion.Press, e);
		hook.KeyReleased += (sender, e) => Handle(KeyMotion.Release, e);
		hook.Run();
	}
}
