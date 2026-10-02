[![ko-fi banner2](https://github.com/user-attachments/assets/42eff455-5757-4888-ad88-d61893edcc33)](https://ko-fi.com/zykeresources)

## Dependencies
- https://github.com/ZykeWasTaken/zyke_lib (2.11.3 or newer, for interest point markers)
- https://github.com/ZykeWasTaken/zyke_sounds (optional, for tire sounds)

## Usage
Hold a slashing weapon from `Config.Settings.weapons` and aim at a tire marker, then press the stab keybind (E by default). The player walks up beside the tire and stabs it. Cancel the walk with X, right mouse or the movement keys. With `alwaysShowMarkers` on, tires that can't be slashed still get a marker that says why. Bulletproof tires take the stab but don't burst.

Every slash is validated on the server and the tire is burst on the client that owns the vehicle, so everyone sees it go flat. Locked vehicles sound their alarm, configured under `Config.Settings.alarm`.

### Sounds
With zyke_sounds started, slashed and bulletproof tires play a sound on the vehicle, synced for every nearby player. Copy the `extras/sounds/stabwheels` folder into `zyke_sounds/nui/sounds/`, then restart `zyke_sounds`. Tune or mute each sound under `Config.Settings.sounds`; the resource works without zyke_sounds.

### Server hooks
- `server/can_checks.lua`: `CanSlashTire` allows or denies a slash, for jobs, gangs or cooldowns.
- `server/hooks.lua`: `OnTireSlashed` runs for every slashed tire, for dispatch alerts or logs.

## Credit
- YouKnowErin#6302 (Native help with wheel deflating)
