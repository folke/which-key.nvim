# Changelog

## [3.17.0](https://github.com/folke/which-key.nvim/compare/v3.16.0...v3.17.0) (2025-02-14)


### Features

* **mappings:** allow flagging a mapping as `real`. It will be hidden if there's no real keymap. ([bcfe1e4](https://github.com/folke/which-key.nvim/commit/bcfe1e4596dc0c6cc25a5b14b32f60a81d18c08d))
* **preset:** some extra win keymaps ([ff61f4f](https://github.com/folke/which-key.nvim/commit/ff61f4fe0d21de199c44a9d893395b5005e96270))

## [3.16.0](https://github.com/folke/which-key.nvim/compare/v3.15.0...v3.16.0) (2025-01-05)


### Features

* **icons:** add refactoring ([#923](https://github.com/folke/which-key.nvim/issues/923)) ([7b7e3d0](https://github.com/folke/which-key.nvim/commit/7b7e3d0788957592e12970bbb9e0e14c4cd143d4))


### Bug Fixes

* **mappings:** add missing keybinds for g; & g, ([#924](https://github.com/folke/which-key.nvim/issues/924)) ([57f4438](https://github.com/folke/which-key.nvim/commit/57f4438158e93be6856317e999758ed77f286dd9))

## [3.15.0](https://github.com/folke/which-key.nvim/compare/v3.14.1...v3.15.0) (2024-12-15)


### Features

* **icons:** icons for snacks and profiler ([d533d8a](https://github.com/folke/which-key.nvim/commit/d533d8a2e0da3444986500ecc2fb0528062d6003))


### Bug Fixes

* **config:** load early when executing WhichKey command. Fixes [#912](https://github.com/folke/which-key.nvim/issues/912) ([c890020](https://github.com/folke/which-key.nvim/commit/c8900201501ab6f0dcfabd55c70f6ba03ada3bd8))

## [3.14.1](https://github.com/folke/which-key.nvim/compare/v3.14.0...v3.14.1) (2024-11-28)


### Bug Fixes

* **state:** do proper redraw that works on nightly and on stable ([3a9b162](https://github.com/folke/which-key.nvim/commit/3a9b162026a4ad4b9ee7b09009b8bbe69ba19520))

## [3.14.0](https://github.com/folke/which-key.nvim/compare/v3.13.3...v3.14.0) (2024-11-28)


### Features

* **icons:** add grapple icon ([#838](https://github.com/folke/which-key.nvim/issues/838)) ([c21b71f](https://github.com/folke/which-key.nvim/commit/c21b71ff0bc4e516705811ec6916131e880cb882))


### Bug Fixes

* **state:** use redraw flush to prevent issues with selecting visual line etc. Fixes [#898](https://github.com/folke/which-key.nvim/issues/898) ([3974c2d](https://github.com/folke/which-key.nvim/commit/3974c2d21b117236ec4f5be4e61a9e4f02aa4c46))
* **triggers:** when in macro defer re-checking suspended for 100ms. Fixes [#864](https://github.com/folke/which-key.nvim/issues/864) ([f46556b](https://github.com/folke/which-key.nvim/commit/f46556b2b1bb7dbbd3b1086eaa24ca5db52b1986))


### Performance Improvements

* **state:** only redraw when waiting for a key longer than 200ms ([1c5aeba](https://github.com/folke/which-key.nvim/commit/1c5aeba42861a2cd446156ec8cbb7e7a5b5a9dfd))
* **tree:** small perf optims ([5610eb6](https://github.com/folke/which-key.nvim/commit/5610eb6bd7193e78d31eb399effacd2dfc25dedf))

## [3.13.3](https://github.com/folke/which-key.nvim/compare/v3.13.2...v3.13.3) (2024-09-18)


### Bug Fixes

* **config:** disable wk by default  for terminal mode ([#825](https://github.com/folke/which-key.nvim/issues/825)) ([e7b415c](https://github.com/folke/which-key.nvim/commit/e7b415cc1d9ac9aee180ee5c8e46ca1484ebda78))
* **triggers:** never attach when macro is recording / executing. Fixes [#851](https://github.com/folke/which-key.nvim/issues/851). Fixes [#822](https://github.com/folke/which-key.nvim/issues/822). Fixes [#807](https://github.com/folke/which-key.nvim/issues/807) ([6b023b4](https://github.com/folke/which-key.nvim/commit/6b023b4c29ecc0aad06a51dd14bd2754b43bb0c8))
* **view:** display actual scroll up/down keys in help ([#821](https://github.com/folke/which-key.nvim/issues/821)) ([dafe27a](https://github.com/folke/which-key.nvim/commit/dafe27a06919bc5077db2ee97feec54d0932450e))

## [3.13.2](https://github.com/folke/which-key.nvim/compare/v3.13.1...v3.13.2) (2024-07-24)


### Bug Fixes

* **view:** fix epanded keys. Fixes [#795](https://github.com/folke/which-key.nvim/issues/795) ([f5e0cd5](https://github.com/folke/which-key.nvim/commit/f5e0cd5c7712ac63d8e6184785fb7bdac3b7b50d))

## [3.13.1](https://github.com/folke/which-key.nvim/compare/v3.13.0...v3.13.1) (2024-07-24)


### Bug Fixes

* **state:** better current buf/mode check ([711453b](https://github.com/folke/which-key.nvim/commit/711453bb945433362636e918a5238172ffd21e43))
* **state:** deal with the fact that ModeChanged doesn't always seems to trigger. Fixes [#787](https://github.com/folke/which-key.nvim/issues/787) ([388bd3f](https://github.com/folke/which-key.nvim/commit/388bd3f83de06d1a1758ea6a342cf3ae614401f1))

## [3.13.0](https://github.com/folke/which-key.nvim/compare/v3.12.1...v3.13.0) (2024-07-24)


### Features

* **debug:** add git info to log when using lazy ([550338d](https://github.com/folke/which-key.nvim/commit/550338dc292c014d83687afccb0afb06e3e769f2))

## [3.12.1](https://github.com/folke/which-key.nvim/compare/v3.12.0...v3.12.1) (2024-07-24)


### Bug Fixes

* **node:** dynamic mappings only support functions as rhs. Fixes [#790](https://github.com/folke/which-key.nvim/issues/790) ([ba91db7](https://github.com/folke/which-key.nvim/commit/ba91db72ffc745983f06ca4e7d969101287a9afe))
* **state:** use cached mode. Fixes [#787](https://github.com/folke/which-key.nvim/issues/787). Closes [#789](https://github.com/folke/which-key.nvim/issues/789) ([c1b062a](https://github.com/folke/which-key.nvim/commit/c1b062ae95c3ca3e6eb87c075da991523605d79b))
* **triggers:** check for existing keymaps in the correct buffer. Fixes [#783](https://github.com/folke/which-key.nvim/issues/783) ([977fa23](https://github.com/folke/which-key.nvim/commit/977fa23622425e3c8ae837b9f7c710d9c78bdeab))
* **triggers:** nil error ([dae3bd2](https://github.com/folke/which-key.nvim/commit/dae3bd271826887771a7fb6deec231d2eb344f02))

## [3.12.0](https://github.com/folke/which-key.nvim/compare/v3.11.1...v3.12.0) (2024-07-22)


### Features

* **api:** allow overriding delay. Closes [#778](https://github.com/folke/which-key.nvim/issues/778) ([e6fea48](https://github.com/folke/which-key.nvim/commit/e6fea4889c20f22a7c6267cf1f1d091bc96f8ca0))


### Bug Fixes

* dont expand nodes without children. Fixes [#782](https://github.com/folke/which-key.nvim/issues/782) ([53a1d2a](https://github.com/folke/which-key.nvim/commit/53a1d2a674df5fb667497fe3bbda625c39a2c0e1))

## [3.11.1](https://github.com/folke/which-key.nvim/compare/v3.11.0...v3.11.1) (2024-07-21)


### Bug Fixes

* **config:** keys can be any case. Fixes [#771](https://github.com/folke/which-key.nvim/issues/771) ([0a44d55](https://github.com/folke/which-key.nvim/commit/0a44d55d3bcdf75a134ec57c90aaec1055731014))
* **config:** normalize keys ([c96be9b](https://github.com/folke/which-key.nvim/commit/c96be9bd54ffbc2ec7fc818001cad712119d778c))

## [3.11.0](https://github.com/folke/which-key.nvim/compare/v3.10.0...v3.11.0) (2024-07-20)


### Features

* **icons:** icon for grug-far ([b2a2a0c](https://github.com/folke/which-key.nvim/commit/b2a2a0c9486211da23acdf18087f8203bfbca0e4))
* **state:** detect recursion by users mapping wk manually. Closes [#761](https://github.com/folke/which-key.nvim/issues/761) ([55fa07f](https://github.com/folke/which-key.nvim/commit/55fa07fbbd8a4c6d75399b1d1f9005d146cda22c))
* **view:** expand recursively. Closes [#767](https://github.com/folke/which-key.nvim/issues/767) ([5ae87af](https://github.com/folke/which-key.nvim/commit/5ae87af42914afe8b478ad6cdb3cb179fb73a62b))


### Bug Fixes

* **config:** disable wk by default for insert/command mode ([9d2b2e7](https://github.com/folke/which-key.nvim/commit/9d2b2e7059547c0481db2e93fd98547b26c7c05a))
* **config:** more checks in validate ([bdcc429](https://github.com/folke/which-key.nvim/commit/bdcc429afaecc5896b462b0b07c2b3a9e9c1c60f))
* **mappings:** preset descriptions should not override existing keymap descriptions. Fixes [#769](https://github.com/folke/which-key.nvim/issues/769) ([82d628f](https://github.com/folke/which-key.nvim/commit/82d628f4cfa397cf4bb233bd500e9cd9a018ded1))
* **state:** don't feed count in insert mode. Fixes [#770](https://github.com/folke/which-key.nvim/issues/770) ([63690ff](https://github.com/folke/which-key.nvim/commit/63690ff34a8921c2de44fad289e2e04ee324b031))
* **util:** better `&lt;nop&gt;` check. Fixes [#766](https://github.com/folke/which-key.nvim/issues/766) ([b7b3bd1](https://github.com/folke/which-key.nvim/commit/b7b3bd1b609524472f67e4a69d2bc14b80ea997f))
* **view:** dont set title when no border. Fixes [#764](https://github.com/folke/which-key.nvim/issues/764) ([6e61b09](https://github.com/folke/which-key.nvim/commit/6e61b0904e9c038b6c511c43591ae2d811b4975e))


### Performance Improvements

* prevent expanding nodes when not needed ([78cc92c](https://github.com/folke/which-key.nvim/commit/78cc92c6cb7da88df60227bc334a598a7e772e51))

## [3.10.0](https://github.com/folke/which-key.nvim/compare/v3.9.0...v3.10.0) (2024-07-18)


### Features

* **view:** expand all nodes by default when filter.global = false ([c168905](https://github.com/folke/which-key.nvim/commit/c168905d62d9b8859b261de69910dfb7e3438996))


### Bug Fixes

* **buf:** always use nowait. Fixes [#755](https://github.com/folke/which-key.nvim/issues/755) ([ae1a235](https://github.com/folke/which-key.nvim/commit/ae1a235c53233c58a2f7cc14e5cdd09346cf27ed))
* **buf:** early exit to determine if a trigger is safe to create. Fixes [#754](https://github.com/folke/which-key.nvim/issues/754) ([27e4716](https://github.com/folke/which-key.nvim/commit/27e47163165fee8e45b43d340db9335001403d2f))
* **icons:** added frontier pattern for `ai` ([#760](https://github.com/folke/which-key.nvim/issues/760)) ([6fe0657](https://github.com/folke/which-key.nvim/commit/6fe065716e08550328c471689e6f8c1e42a0effc))
* list_contains doesn't exists in Neovim &lt; 0.10. Fixes [#758](https://github.com/folke/which-key.nvim/issues/758) ([7e4eae8](https://github.com/folke/which-key.nvim/commit/7e4eae8836e4ad28d478fedc421700b1138d1e0c))
* **node:** allow custom mappings to override proxy/plugin/expand mappings ([9820900](https://github.com/folke/which-key.nvim/commit/982090080fa11da06038cf8e71af90d3a4fbd05a))
* **node:** is_local check now also includes children ([fdd27f9](https://github.com/folke/which-key.nvim/commit/fdd27f9b6a991586943eb865275b279fb411ff0b))
* **registers:** don't try to get `+*` registers when no clipboard is available. Fixes [#754](https://github.com/folke/which-key.nvim/issues/754) ([ae4ec03](https://github.com/folke/which-key.nvim/commit/ae4ec030489d7ecda908e473aea096a7594f84e8))
* **state:** always honor defer. Fixes [#690](https://github.com/folke/which-key.nvim/issues/690) ([c512d13](https://github.com/folke/which-key.nvim/commit/c512d135531be81e17c85e254994cc755d3016c5))
* **state:** redraw cursor before getchar ([cf6cbf2](https://github.com/folke/which-key.nvim/commit/cf6cbf2fd8f0c6497f130d07f6c88a2833c15d80))
* **triggers:** prevent creating triggers for single upper-case alpha keys expect for Z. Fixes [#756](https://github.com/folke/which-key.nvim/issues/756) ([d19fa07](https://github.com/folke/which-key.nvim/commit/d19fa07b6e818ab55c34815784470a6d5f023524))

## [3.9.0](https://github.com/folke/which-key.nvim/compare/v3.8.0...v3.9.0) (2024-07-18)


### Features

* **config:** simplified config. Some options are now deprecated ([8ddf2da](https://github.com/folke/which-key.nvim/commit/8ddf2da5a6aa76f5b3cec976f1d61e7c7fea42b5))
* **view:** show and expand localleader mappings with filter.global = false ([ed5f762](https://github.com/folke/which-key.nvim/commit/ed5f7622771d0b5c0ac3a5e286ec6cd17b6be131))


### Bug Fixes

* **ui:** remove deprecated opts.layout.align option. (wasn't used). Closes [#752](https://github.com/folke/which-key.nvim/issues/752) ([db32ac6](https://github.com/folke/which-key.nvim/commit/db32ac67abb36789a43fe497ff7d0b8ab7e8109e))

## [3.8.0](https://github.com/folke/which-key.nvim/compare/v3.7.0...v3.8.0) (2024-07-17)


### Features

* **mappings:** added health check for invalid modes ([640724a](https://github.com/folke/which-key.nvim/commit/640724a541af75e6bbfe98f78cdebbec701d23a8))


### Bug Fixes

* **buf:** never create proxy/plugin mappings when a keymap exists. Fixes [#738](https://github.com/folke/which-key.nvim/issues/738) ([b4c4e36](https://github.com/folke/which-key.nvim/commit/b4c4e3648261399a97bfdc44bb8fa31b485fd3b9))
* **registers:** use x instead of v ([#742](https://github.com/folke/which-key.nvim/issues/742)) ([5c3b3e8](https://github.com/folke/which-key.nvim/commit/5c3b3e834852a44efb26725f9c08917145f2c0c6))
* **state:** schedule redraw. Fixes [#740](https://github.com/folke/which-key.nvim/issues/740) ([09f21a1](https://github.com/folke/which-key.nvim/commit/09f21a133104b66a5cede8fc0a8082b85b0eee9b))
* **triggers:** allow overriding keymaps with empty rhs or &lt;Nop&gt;. Fixes [#748](https://github.com/folke/which-key.nvim/issues/748) ([843a93f](https://github.com/folke/which-key.nvim/commit/843a93fac6bca58167aafa392e6f7fd5a77633c9))
* **triggers:** make sure no keymaps exists for triggers ([e8b454f](https://github.com/folke/which-key.nvim/commit/e8b454fb03e3cab398c894e5d462c84595ee57ca))
* **typo:** replace 'exras' for 'extras' in README. ([#745](https://github.com/folke/which-key.nvim/issues/745)) ([af48cdc](https://github.com/folke/which-key.nvim/commit/af48cdc4bb8f1982a6124bf6bb5570349f690822))

## [3.7.0](https://github.com/folke/which-key.nvim/compare/v3.6.0...v3.7.0) (2024-07-17)


### Features

* added `expand` property to create dynamic mappings. An example for `buf` and `win` is included ([02f6e6f](https://github.com/folke/which-key.nvim/commit/02f6e6f4951ff993ad1d5c699784e6847a6c7b4c))
* proxy mappings ([c3cfc2b](https://github.com/folke/which-key.nvim/commit/c3cfc2bdb03c1b87943a6d02485ad50b86567341))
* **state:** allow defering on certain operators. Closes [#733](https://github.com/folke/which-key.nvim/issues/733) ([984d930](https://github.com/folke/which-key.nvim/commit/984d930711341ac118e6712804e8e22e575ba9d3))


### Bug Fixes

* **buf:** create triggers for xo anyway. Fixes [#728](https://github.com/folke/which-key.nvim/issues/728) ([96b2e93](https://github.com/folke/which-key.nvim/commit/96b2e93979373744056c921f82b0c356e6f900de))
* **icons:** added frontier pattern for `git`. Fixes [#727](https://github.com/folke/which-key.nvim/issues/727) ([bb4e82b](https://github.com/folke/which-key.nvim/commit/bb4e82bdaff50a4a93867e4c90938d18e7615af6))
* **state:** dont popup when switching between v and V mode. Fixes [#729](https://github.com/folke/which-key.nvim/issues/729) ([8ddb527](https://github.com/folke/which-key.nvim/commit/8ddb527bcffc6957a59518f11c34a84d91e075f9))
* **view:** always show a group as a group ([96a9eb3](https://github.com/folke/which-key.nvim/commit/96a9eb3f0b3299dffc241cf0f9ee5cf0509e6cd2))
* **view:** empty icons ([e2cacc6](https://github.com/folke/which-key.nvim/commit/e2cacc6f1e4ba77e82e7a34e0dc6b2ad69cf075b))

## [3.6.0](https://github.com/folke/which-key.nvim/compare/v3.5.0...v3.6.0) (2024-07-16)


### Features

* added icons for &lt;D mappings ([aaf71ab](https://github.com/folke/which-key.nvim/commit/aaf71ab078d86a48a26fafb5d451af609fd19c64))
* added option to disable all mapping icons. Fixes [#721](https://github.com/folke/which-key.nvim/issues/721) ([33f6ac0](https://github.com/folke/which-key.nvim/commit/33f6ac04bdbce855ce43eecacb4c421876e246d7))
* make which-key work without setup or calling add/register ([9ca5f4a](https://github.com/folke/which-key.nvim/commit/9ca5f4ab7cb541ef48dcaa4f03d3cd914a5e62fb))
* **presets:** added some missing mappings ([6e1b3f2](https://github.com/folke/which-key.nvim/commit/6e1b3f290a3f89ffca68148aa639c866c24e2b77))
* **state:** improve trigger/mode logic. Fixes [#715](https://github.com/folke/which-key.nvim/issues/715) ([3617e47](https://github.com/folke/which-key.nvim/commit/3617e47673d027989e9c3caa645edb6412c7fa30))


### Bug Fixes

* **config:** replacement for plug mappings ([495f9d9](https://github.com/folke/which-key.nvim/commit/495f9d953a86d630ef308f555ed452e332f417ee))
* **icons:** get icons from parent nodes when needed ([3f0a7ed](https://github.com/folke/which-key.nvim/commit/3f0a7ed4401b98764740cbe8e1b954ac6adeca1b))
* **icons:** use nerdfont symbol for BS. Fixes [#722](https://github.com/folke/which-key.nvim/issues/722) ([18c1ff5](https://github.com/folke/which-key.nvim/commit/18c1ff5ccb813d95c86f4ead6dac7e6cc5728f08))
* **mode:** never create triggers for xo mode ([15d3a70](https://github.com/folke/which-key.nvim/commit/15d3a70304607417b2dc1df3da4992d5b8ce077a))
* **presets:** motions in normal mode ([e2ffc26](https://github.com/folke/which-key.nvim/commit/e2ffc263fc05bf20f090ccaae7a06f88fd6e2fee))
* tmp fix for op mode ([91641e2](https://github.com/folke/which-key.nvim/commit/91641e2a3af116ffaf739302a65cdb2865fb2415))
* **view:** fix format for keymaps with 3+ keys ([#723](https://github.com/folke/which-key.nvim/issues/723)) ([0db7896](https://github.com/folke/which-key.nvim/commit/0db7896057d046576c829a87e2ff2de37c49e0fe))

## [3.5.0](https://github.com/folke/which-key.nvim/compare/v3.4.0...v3.5.0) (2024-07-15)


### Features

* **api:** using wk.show() always assumes you want to see the group, and not the actual mapping in case of overlap. Fixes [#714](https://github.com/folke/which-key.nvim/issues/714) ([f5067d2](https://github.com/folke/which-key.nvim/commit/f5067d2b244c19eca38b5b495b6eb3e361ac565d))


### Bug Fixes

* **state:** attach on BufNew as well. Fixes [#681](https://github.com/folke/which-key.nvim/issues/681) ([0f58176](https://github.com/folke/which-key.nvim/commit/0f581764dc2c89c0ac3d8363369152735ae265ab))
* **state:** make sure mode always exists even when not safe. See [#681](https://github.com/folke/which-key.nvim/issues/681) ([7915964](https://github.com/folke/which-key.nvim/commit/7915964e73c30ba5657e9a762c6570925dad421b))


### Performance Improvements

* **plugin:** only expand plugins when needed ([1fcfc72](https://github.com/folke/which-key.nvim/commit/1fcfc72374c705d68f0607a1dcbbbce13873b4e2))
* **view:** set buf/win opts with eventignore ([e81e55b](https://github.com/folke/which-key.nvim/commit/e81e55b647a781f306453734834eb543e1f43c20))

## [3.4.0](https://github.com/folke/which-key.nvim/compare/v3.3.0...v3.4.0) (2024-07-15)


### Features

* added icons for function keys ([9222280](https://github.com/folke/which-key.nvim/commit/9222280970e8a7d74b4e0f6dab06c2f7a54d668d))
* **mode:** allow certain modes to start hidden and only show after keypress. See [#690](https://github.com/folke/which-key.nvim/issues/690) ([b4fa48f](https://github.com/folke/which-key.nvim/commit/b4fa48f473796f5d9e3c9c31e6c9d7d509e51ca6))
* **presets:** added gw ([09b80a6](https://github.com/folke/which-key.nvim/commit/09b80a68085c1fc792b595a851f702bc071d6310))
* **presets:** better padding defaults for helix preset ([4c36b9b](https://github.com/folke/which-key.nvim/commit/4c36b9b8c722bcf51d038dcfba8b967f0ee818b8))
* **presets:** increase default height for helix ([df0ad20](https://github.com/folke/which-key.nvim/commit/df0ad205ebd661ef101666ae21a62b77b3024a83))
* simplified/documented/fixed mappings sorting. Closes [#694](https://github.com/folke/which-key.nvim/issues/694) ([eb73f7c](https://github.com/folke/which-key.nvim/commit/eb73f7c05785a83e07f1ea155b3b2833d8bbb532))
* **state:** skip mouse keys in debug ([5f85b77](https://github.com/folke/which-key.nvim/commit/5f85b770c386c9435eb8da5db3081aa19078211a))
* **ui:** show keys/help in an overlay and added scrolling hint ([50b2c43](https://github.com/folke/which-key.nvim/commit/50b2c43532e6ea5cca3ef4c2838d5a8bb535757f))
* **view:** get parent icon if possible ([b9de927](https://github.com/folke/which-key.nvim/commit/b9de9278bdc57adfa69a67d8a3309f07c83951d0))


### Bug Fixes

* **buf:** always detach " when executing keys. Fixes [#689](https://github.com/folke/which-key.nvim/issues/689) ([d36f722](https://github.com/folke/which-key.nvim/commit/d36f722f114dfdafc8098496e9b5dcbd9f8fc3e8))
* **config:** set expand=0 by default. Fixes [#693](https://github.com/folke/which-key.nvim/issues/693) ([89434aa](https://github.com/folke/which-key.nvim/commit/89434aa356abd4a694d2b89eccb203e0742bc0d7))
* **config:** warn when deprecated config options were used. Fixes [#696](https://github.com/folke/which-key.nvim/issues/696) ([81413ef](https://github.com/folke/which-key.nvim/commit/81413ef02dffbe6e4c73f418e4acc920e68b3aa7))
* **health:** move deprecated option check to health ([af7a30f](https://github.com/folke/which-key.nvim/commit/af7a30fa24ce0a13dba00cbd7b836330facf9f1a))
* **mappings:** allow creating keymaps without desc. Fixes [#695](https://github.com/folke/which-key.nvim/issues/695) ([c442aaa](https://github.com/folke/which-key.nvim/commit/c442aaa6aafe2742c2e92df7ee127df90099ce17))
* **plugins:** add existing keymaps to plugin view. Fixes [#681](https://github.com/folke/which-key.nvim/issues/681) ([26f6fd2](https://github.com/folke/which-key.nvim/commit/26f6fd258b66e9656bb86c7269c6497a9ce8a5fa))
* **presets:** don't override title setting for classic. See [#649](https://github.com/folke/which-key.nvim/issues/649) ([9a53c1f](https://github.com/folke/which-key.nvim/commit/9a53c1ff46421450b5563baab1599591d81de111))
* **presets:** shorter descriptions ([20600e4](https://github.com/folke/which-key.nvim/commit/20600e422277b383e8c921feec2111a281935217))
* **state:** always do full update on BufReadPost since buffer-local keymaps would be deleted. Fixes [#709](https://github.com/folke/which-key.nvim/issues/709) ([6068887](https://github.com/folke/which-key.nvim/commit/60688872f4ecc552a5e2bcbd01e7629a155f377f))
* **state:** don't show when coming from cmdline mode. Fixes [#692](https://github.com/folke/which-key.nvim/issues/692) ([8cba66b](https://github.com/folke/which-key.nvim/commit/8cba66b5a1a0ea8fe8dd5d3d55a42755924e47d8))
* **state:** honor timeoutlen and nowait. Fixes [#648](https://github.com/folke/which-key.nvim/issues/648). Closes [#697](https://github.com/folke/which-key.nvim/issues/697) ([80f20ee](https://github.com/folke/which-key.nvim/commit/80f20ee62311505fe6d675212f7b246900570450))
* **state:** properly disable which-key when recording macros. Fixes [#702](https://github.com/folke/which-key.nvim/issues/702) ([b506275](https://github.com/folke/which-key.nvim/commit/b506275acfb4383f678b9ba3aa8db88787c24680))
* **state:** scrolling ([dce9167](https://github.com/folke/which-key.nvim/commit/dce9167025a0801e4bab146a2856508a9af52ea2))
* **tree:** rawget for existing plugin node children ([c77cda8](https://github.com/folke/which-key.nvim/commit/c77cda8cd2f54965e4316699f1d124a2b3bf9d49))
* **util:** when no clipboard provider exists, use the " register as default. Fixes [#687](https://github.com/folke/which-key.nvim/issues/687) ([d077a3f](https://github.com/folke/which-key.nvim/commit/d077a3f36d4b4d29eccc7feb1ba8e78a421df920))
* **view:** disable footer on Neovim &lt; 0.10 ([6d544a4](https://github.com/folke/which-key.nvim/commit/6d544a43a21a228482155d65c3ca18fd7038b422))
* **view:** ensure highlights get set for title padding ([#684](https://github.com/folke/which-key.nvim/issues/684)) ([2e4f7af](https://github.com/folke/which-key.nvim/commit/2e4f7afa4aa444483d8ade5989d524c7f4131368))
* **view:** hide existing title/footer when no trail ([4f589a1](https://github.com/folke/which-key.nvim/commit/4f589a1368e100a6e33aabd904f34716b75360f6))
* **view:** include group keymaps in expand results. See [#682](https://github.com/folke/which-key.nvim/issues/682) ([39e703c](https://github.com/folke/which-key.nvim/commit/39e703ceaa9a05dcc664e0ab0ea88c03c3b6bf90))
* **view:** overlap protection should keep at least 4 lines ([0d89475](https://github.com/folke/which-key.nvim/commit/0d89475f87756199efc2bc52537fc4d11b0f695a))
* **view:** padding & column spacing. Fixes [#704](https://github.com/folke/which-key.nvim/issues/704) ([11eec49](https://github.com/folke/which-key.nvim/commit/11eec49509490c023bf0272efef955f86f18c1d2))
* **view:** spacing when more than one box ([89568f3](https://github.com/folke/which-key.nvim/commit/89568f3438f1fbc6c340a8af05ea67feac494c46))
* **view:** special handling of `&lt;NL&gt;/<C-J>`. Fixes [#706](https://github.com/folke/which-key.nvim/issues/706) ([f8c91b2](https://github.com/folke/which-key.nvim/commit/f8c91b2b4a2d239d3b1d49f901a393e7326a5da8))

## [3.3.0](https://github.com/folke/which-key.nvim/compare/v3.2.0...v3.3.0) (2024-07-14)


### Features

* **expand:** allow expand to be a function. Closes [#670](https://github.com/folke/which-key.nvim/issues/670) ([dfaa10c](https://github.com/folke/which-key.nvim/commit/dfaa10cd24badb321a4667fb9135f242393e5680))
* **mappings:** mapping `desc` and `icon` can now be a function that is evaluated when which-key is show. Fixes [#666](https://github.com/folke/which-key.nvim/issues/666) ([c634af1](https://github.com/folke/which-key.nvim/commit/c634af1295512dc2062fbec38f563f5793de245c))
* **mappings:** opts.filter to exclude certain mappings from showing up in which-key. ([763ea00](https://github.com/folke/which-key.nvim/commit/763ea000cce9589124515ba34f6d9a6347a02891))
* **view:** add operator to trail in op mode ([5a6eaaa](https://github.com/folke/which-key.nvim/commit/5a6eaaa4ebc072625b9fc906943e3798028bd817))
* **view:** when in visual mode, propagate esc. See [#656](https://github.com/folke/which-key.nvim/issues/656) ([30ef44a](https://github.com/folke/which-key.nvim/commit/30ef44a13065a157f97d3fb5bbf23a5c23e513eb))


### Bug Fixes

* default preset ([38987d3](https://github.com/folke/which-key.nvim/commit/38987d3f18a8ffc5eaa404d746fd8ee4017b5f37))
* **mappings:** don't show `&lt;SNR&gt;` mappings ([d700244](https://github.com/folke/which-key.nvim/commit/d700244acc1f1474b34737e14a45df2aa3a324ba))
* **presets:** max 1 column in helix mode. Fixes [#665](https://github.com/folke/which-key.nvim/issues/665) ([b2a6910](https://github.com/folke/which-key.nvim/commit/b2a6910e9e97526f2327327d2751834049cbd334))
* **presets:** shorter descriptions ([9a73d6a](https://github.com/folke/which-key.nvim/commit/9a73d6a0b0d5f456a9768d434a83d6d4cdb83efa))
* **state:** cooldown till next tick when not safe to open which-key. Fixes [#672](https://github.com/folke/which-key.nvim/issues/672) ([bdf3b27](https://github.com/folke/which-key.nvim/commit/bdf3b272ea34ac137af3cb1ebcd5cf8c9745abbb))
* **util:** nt mode should map to n ([969afc9](https://github.com/folke/which-key.nvim/commit/969afc95d374bc0d6ce397d3d2357d8faa38041a))
* **view:** set nowrap for the which-key window ([6e1c098](https://github.com/folke/which-key.nvim/commit/6e1c0987024adf63ab91f281f8f9c355abf3f3d8))
* **view:** set winhl groups. Fixes [#661](https://github.com/folke/which-key.nvim/issues/661) ([baff8ea](https://github.com/folke/which-key.nvim/commit/baff8ea846cbb613dee79333aad7a1d2b912a5bc))

## [3.2.0](https://github.com/folke/which-key.nvim/compare/v3.1.0...v3.2.0) (2024-07-13)


### Features

* added `opts.debug` that writes to wk.log in the current directory ([c23df71](https://github.com/folke/which-key.nvim/commit/c23df711884d97963d0c17ed29f5d8c1064d4adc))
* hydra mode. will document later ([65f2e72](https://github.com/folke/which-key.nvim/commit/65f2e7236a3bc278dd163d7c98c9ea5d9ab6e42e))
* **icons:** add telescope icon ([#643](https://github.com/folke/which-key.nvim/issues/643)) ([fca3d9e](https://github.com/folke/which-key.nvim/commit/fca3d9eaef57ddb3ce438d208ebc32e23c9f290a))


### Bug Fixes

* layout stuff ([7423096](https://github.com/folke/which-key.nvim/commit/742309697cff6aa7f377b72e2f54d34afef09ee1))
* **mappings:** always use mapping even when it's creating a keymap. Fixes [#637](https://github.com/folke/which-key.nvim/issues/637) ([2d744cb](https://github.com/folke/which-key.nvim/commit/2d744cb824c0f310be420bf33688bc005f164f46))
* **mappings:** make replace_keycodes default to false in v1 spec ([6ec0a1e](https://github.com/folke/which-key.nvim/commit/6ec0a1ef89209680c799269227b4d0c28de1d877))
* **state:** dont start which-key during dot repeat. Fixes [#636](https://github.com/folke/which-key.nvim/issues/636) ([5971ecd](https://github.com/folke/which-key.nvim/commit/5971ecdf4465425d6bc6e2277101c6fc896cbe06))
* **state:** dont start which-key more than once during the same tick in xo mode. Fixes [#635](https://github.com/folke/which-key.nvim/issues/635) ([0218fce](https://github.com/folke/which-key.nvim/commit/0218fce1c3d54307217391215db28e63de9b8980))
* **state:** dont start wk when chars are pending. Fixes [#658](https://github.com/folke/which-key.nvim/issues/658). Fixes [#655](https://github.com/folke/which-key.nvim/issues/655). Fixes [#648](https://github.com/folke/which-key.nvim/issues/648) ([877ce16](https://github.com/folke/which-key.nvim/commit/877ce163d764bbe7c82a7fec5671c32188607754))
* **state:** only hide on focus lost when still hidden after 1s. Fixes [#638](https://github.com/folke/which-key.nvim/issues/638) ([649a51b](https://github.com/folke/which-key.nvim/commit/649a51bc81b09443c326d390e3d182e0cdf98c15))
* **types:** spec field types ([#645](https://github.com/folke/which-key.nvim/issues/645)) ([c6ffb1c](https://github.com/folke/which-key.nvim/commit/c6ffb1ce63959d5f1effe5924712f36eac1e940e))
* **util:** set local window opts for notify. Fixes [#641](https://github.com/folke/which-key.nvim/issues/641) ([63f2112](https://github.com/folke/which-key.nvim/commit/63f2112361a53b0cf68245868977773f210bb5cd))
* **view:** check for real overlap instead of just row overlap. See [#649](https://github.com/folke/which-key.nvim/issues/649) ([0427e91](https://github.com/folke/which-key.nvim/commit/0427e91dbbd9c37eb20e6fbc2386f890dc0d7e2a))
* **view:** disable folds. Fixes [#99](https://github.com/folke/which-key.nvim/issues/99) ([6860e3b](https://github.com/folke/which-key.nvim/commit/6860e3b681b40e3620049f714ae53a6bad594701))

## [3.1.0](https://github.com/folke/which-key.nvim/compare/v3.0.0...v3.1.0) (2024-07-12)


### Features

* allow disabling any trigger ([94b7951](https://github.com/folke/which-key.nvim/commit/94b795154fb213db6ed8aeba3d7f53cbce7c147c))


### Bug Fixes

* added support for vim.loop ([54db192](https://github.com/folke/which-key.nvim/commit/54db1928c17ac420e897a40f5ad560ee9f28b186))
* automatically do setup if setup wasn't called within 500ms. Fixes [#630](https://github.com/folke/which-key.nvim/issues/630) ([632ad41](https://github.com/folke/which-key.nvim/commit/632ad41b5fcf60fac897d0b6530a699eb980748d))
* **buf:** buffer-local mappings were broken (not keymaps). Fixes [#629](https://github.com/folke/which-key.nvim/issues/629) ([58d7f82](https://github.com/folke/which-key.nvim/commit/58d7f822ecc80ca4b43e9c14fd6ec962483e2168))
* **colors:** compat with older Neovim vesions. Fixes [#631](https://github.com/folke/which-key.nvim/issues/631) ([4516dc9](https://github.com/folke/which-key.nvim/commit/4516dc9422f571c9e189ff6696853d445a3058d6))

## [3.0.0](https://github.com/folke/which-key.nvim/compare/v2.1.0...v3.0.0) (2024-07-12)


### ⚠ BREAKING CHANGES

* v3 release

### Features

* added health check back with better wording on what actually gets checked ([97e6e41](https://github.com/folke/which-key.nvim/commit/97e6e4166134aad826454588ae764c7a54f5d298))
* added WhichKey command ([7c12ab9](https://github.com/folke/which-key.nvim/commit/7c12ab9c2569a7459932bc19a4e52ea5a48437b2))
* automatically use nowait based on delay and timeoutlen ([110ed72](https://github.com/folke/which-key.nvim/commit/110ed728bedd0182e4d11726194f7eb5db63e2fb))
* bring config back and create mappings when needed ([add7ab9](https://github.com/folke/which-key.nvim/commit/add7ab92163399c47f7149c96387d382e9d8996b))
* buffer-local sort & refactor API ([14309d0](https://github.com/folke/which-key.nvim/commit/14309d0446dcc6a24421c56e914e06b1fe2d4f41))
* close which-key on FocusLost ([aa99460](https://github.com/folke/which-key.nvim/commit/aa99460e117d0348c7f1f77ab669398c04fcba6b))
* config, and presets ([541989d](https://github.com/folke/which-key.nvim/commit/541989db167e04eb3db24ba57decab0326614f0f))
* expand groups with less than n mappings. Closes [#374](https://github.com/folke/which-key.nvim/issues/374). Fixes [#90](https://github.com/folke/which-key.nvim/issues/90). Closes [#208](https://github.com/folke/which-key.nvim/issues/208) ([5caf057](https://github.com/folke/which-key.nvim/commit/5caf057b3a204a94d53b4b0200ce915463b4a922))
* fancy key icons ([e4d0134](https://github.com/folke/which-key.nvim/commit/e4d01347434b31e8a90720463076bbbeebbef199))
* fix hidden and empty groups ([afc4aa9](https://github.com/folke/which-key.nvim/commit/afc4aa96ae5671f5d4d14f332789dec72dd5db02))
* **health:** duplicate mappings check ([4762e06](https://github.com/folke/which-key.nvim/commit/4762e06f9dc45b3470ab5b2efa0a4b3de6148298))
* **health:** icon providers & overlapping keys ([dcbf29a](https://github.com/folke/which-key.nvim/commit/dcbf29ae337bd4d621e326b6f1caad66cfe0770a))
* initial rewrite ([eb3ad2e](https://github.com/folke/which-key.nvim/commit/eb3ad2eb062392497d0fed3489e2582d4e5bc289))
* keep track of virtual mappings ([4537d3e](https://github.com/folke/which-key.nvim/commit/4537d3ea52b2b11b96ca2fdde2bb4573f0ca7c73))
* key/desc replacements ([cf34ffe](https://github.com/folke/which-key.nvim/commit/cf34ffe9384941dc833ed2a3bb2a3bf3aa050373))
* layout ([347288a](https://github.com/folke/which-key.nvim/commit/347288acd8398ae7c641bd6159261e98f9a6b929))
* manual sorting. Closes [#131](https://github.com/folke/which-key.nvim/issues/131), Closes [#362](https://github.com/folke/which-key.nvim/issues/362), Closes [#264](https://github.com/folke/which-key.nvim/issues/264) ([c2daf9d](https://github.com/folke/which-key.nvim/commit/c2daf9dcf48e8c8cca61cfc27b1731272b9bc2c6))
* **mappings:** added support for lazy.nvim style mappings ([6f7a945](https://github.com/folke/which-key.nvim/commit/6f7a945f1dc679ce2c35064e12e4dc531ebf2c3c))
* **mappings:** added support for setting custom icons from the spec ([951ae7a](https://github.com/folke/which-key.nvim/commit/951ae7a89d164f39f8aa49f51da424539370f6c4))
* new spec and migration recommendation for health ([41374bc](https://github.com/folke/which-key.nvim/commit/41374bcae462d897fa98c904a44127e258c0438c))
* option to disable icon colors ([79c8ac8](https://github.com/folke/which-key.nvim/commit/79c8ac87139dcb816072c1a5ca1800d9ce5d64aa))
* option to disable notify ([4cc46ff](https://github.com/folke/which-key.nvim/commit/4cc46ffa57b8a6ebf6ca7a07128d353f5569a802))
* play nice with macros ([1abc2bf](https://github.com/folke/which-key.nvim/commit/1abc2bf96472e7816252719de06d60e9b09035dc))
* plugins partially working again ([b925b31](https://github.com/folke/which-key.nvim/commit/b925b31bab1f91507d15a96f226f7f7423c4fced))
* **registers:** show non-printable with keytrans ([1832197](https://github.com/folke/which-key.nvim/commit/183219772d01e0ea744c0ff8bf656895f7d7c8d3))
* spec parser rewrite & proper typings ([07065fe](https://github.com/folke/which-key.nvim/commit/07065fe345bc9dd20aff11ab9a6a3b078aacd42e))
* state management ([e2ee1fa](https://github.com/folke/which-key.nvim/commit/e2ee1fae13f7a6c38652994dedb0cb34e2608918))
* state management ([e6beb88](https://github.com/folke/which-key.nvim/commit/e6beb8845e80558194c6027b7a985e1211e76878))
* title trail ([aef2e53](https://github.com/folke/which-key.nvim/commit/aef2e535c5b7c8f100b534a4b781a82e36f20e39))
* **ui:** added scrolling ([5f1ab35](https://github.com/folke/which-key.nvim/commit/5f1ab35d099a252f204e2806747980c192a9c265))
* **ui:** keymap icons ([21d7108](https://github.com/folke/which-key.nvim/commit/21d71081d86872189a3ce90b7c13593f15b78459))
* **ui:** sorters ([ffeea79](https://github.com/folke/which-key.nvim/commit/ffeea7933249d5ce33b2b3838171cc5299ef1893))
* update ui when new mappings become available ([a8f66f5](https://github.com/folke/which-key.nvim/commit/a8f66f5ebd9b94f409a88c4a77244167f6edd05f))
* v3 release ([da258a8](https://github.com/folke/which-key.nvim/commit/da258a89a700916ad0e6af1ad8f9889ff0308253))
* **view:** nerd font icons for cmd keys ([2787dbd](https://github.com/folke/which-key.nvim/commit/2787dbd158184af67ead5af5bcc0cbdb17856c31))


### Bug Fixes

* **api:** show view immediately when opened through the API ([b0e0af0](https://github.com/folke/which-key.nvim/commit/b0e0af0957a648735a43fae52ef34059721f7b42))
* autmatically blacklist all single key hooks except for z and g ([87c5a4b](https://github.com/folke/which-key.nvim/commit/87c5a4b1be1f882c8b27252464d777a76ea15839))
* **icons:** check that mini icons hl groups exist in the current colorscheme. If not use which-key default groups ([2336350](https://github.com/folke/which-key.nvim/commit/233635039bf828e341f5ca9b4b8444ac3c56b974))
* **icons:** proper icons check ([2eaed99](https://github.com/folke/which-key.nvim/commit/2eaed99585f08787d6b5060c89184973eb5aa276))
* **keys:** delete nop keymaps with a description ([ccf0276](https://github.com/folke/which-key.nvim/commit/ccf027625df6c4e22febfdd786c5e1f7521c2ccb))
* **layout:** display vs multibyte ellipsis ([0442a73](https://github.com/folke/which-key.nvim/commit/0442a7340cebe13cc5a5fd70dd6cdc989f9086fe))
* **layout:** empty columns ([600881a](https://github.com/folke/which-key.nvim/commit/600881a9b0cf8119819a97d8900d99fd7a406d36))
* op-mode, count and reg ([e4d54d1](https://github.com/folke/which-key.nvim/commit/e4d54d11cc247edd0ed4bde7a501caa8e119c1ff))
* pcall keymap.del ([e47ee13](https://github.com/folke/which-key.nvim/commit/e47ee139b6a082deab16e436cbd2711923e01625))
* plugin actions & spelling ([e7da411](https://github.com/folke/which-key.nvim/commit/e7da411b45415e8d0d6a5e14b9c1bd5207d09869))
* presets ([bcf52ba](https://github.com/folke/which-key.nvim/commit/bcf52ba08a57a90e85d4397245a0350c34f2b9d1))
* readme ([5fe6c91](https://github.com/folke/which-key.nvim/commit/5fe6c91e6f2d7d6dd1a8473ac0cd9bbe311512d9))
* respect mappings with `&lt;esc&gt;` and close on cursor moved ([22deda5](https://github.com/folke/which-key.nvim/commit/22deda5458b15a10b02b516c68dd409cbaeb53f4))
* set check debounce to 50 ([754bcc7](https://github.com/folke/which-key.nvim/commit/754bcc7be77b9f9ecac02598121eb97a243b7efa))
* **state:** dont return or autocmd will cancel ([9a77986](https://github.com/folke/which-key.nvim/commit/9a779869ef557ff6fa84a8b0b478a0f84781c67e))
* **state:** keyboard interrupts ([1ed9182](https://github.com/folke/which-key.nvim/commit/1ed91823d47f34ce5c52da9ca14e202606caf215))
* **state:** make sure the buffer mode exists when changing modes ([df64366](https://github.com/folke/which-key.nvim/commit/df64366d8633ac13ba2da7134cc6bbe242a97237))
* stuff ([f67eb19](https://github.com/folke/which-key.nvim/commit/f67eb192ca6d579add84086d4d1b4ce6ce8732ac))
* **tree:** check for which_key_ignore in existing keymaps ([f17d78b](https://github.com/folke/which-key.nvim/commit/f17d78bdf8a0afce5bec97c70e68203a6cddf2b7))
* **ui:** box height ([528fc43](https://github.com/folke/which-key.nvim/commit/528fc43b87cfc29bbc1dddc17051a99cdfdf9ad2))
* **ui:** make sure the which-key window never overlaps the user's cursor position ([1bb30a7](https://github.com/folke/which-key.nvim/commit/1bb30a7a6901aa842f31c96af7009ef645b29edd))
* **ui:** scroll and topline=1 on refresh ([28b648d](https://github.com/folke/which-key.nvim/commit/28b648daeabfd2aad8496ffc7a2096bf7d2441b5))
* which_key_ignore ([ab5ffa8](https://github.com/folke/which-key.nvim/commit/ab5ffa83b4f10ea2360a32d855b016f72a2be6b6))
* which-key ignore and cleanup ([aeae826](https://github.com/folke/which-key.nvim/commit/aeae826f948cbaeb3a89d9025c423e8300cb5dd3))

## [2.1.0](https://github.com/folke/which-key.nvim/compare/v2.0.1...v2.1.0) (2024-06-06)


### Features

* **presets:** add descriptions for fold deletion ([#504](https://github.com/folke/which-key.nvim/issues/504)) ([53b6085](https://github.com/folke/which-key.nvim/commit/53b6085367a92740664783330583facd958dbceb))


### Bug Fixes

* black hole z= replacements ([#602](https://github.com/folke/which-key.nvim/issues/602)) ([f5b9124](https://github.com/folke/which-key.nvim/commit/f5b912451f33fd19e52230e73617ad099ffd3ab1))
* **keys:** fix nested operators. See [#600](https://github.com/folke/which-key.nvim/issues/600). Fixes [#609](https://github.com/folke/which-key.nvim/issues/609) ([25d5b9e](https://github.com/folke/which-key.nvim/commit/25d5b9e9b5775525248b8d5c95271ba28f75d326))
* restore win view after rendering buffer ([#516](https://github.com/folke/which-key.nvim/issues/516)) ([ea4a17d](https://github.com/folke/which-key.nvim/commit/ea4a17d63571c81f529669a373d20c855b9b351d)), closes [#515](https://github.com/folke/which-key.nvim/issues/515)
* support nested operators ([#600](https://github.com/folke/which-key.nvim/issues/600)) ([476f4ca](https://github.com/folke/which-key.nvim/commit/476f4cacb15da81dcebe68ea45333e660409612d))

## [2.0.1](https://github.com/folke/which-key.nvim/compare/v2.0.0...v2.0.1) (2024-06-06)


### Bug Fixes

* label -&gt; desc ([b8eb534](https://github.com/folke/which-key.nvim/commit/b8eb5348a749e214dfd08d38654a736d91191918))

## [2.0.0](https://github.com/folke/which-key.nvim/compare/v1.6.1...v2.0.0) (2024-06-06)


### ⚠ BREAKING CHANGES

* which-key now requires Neovim >= 0.9

### Features

* **keys:** `desc` in `"&lt;nop&gt;"` or `""` keymaps can now become prefix label ([#522](https://github.com/folke/which-key.nvim/issues/522)) ([c1958e2](https://github.com/folke/which-key.nvim/commit/c1958e2529433ef096e924c72315733790ca7f88))
* **mappings:** check if desc exists when parsing mappings ([#589](https://github.com/folke/which-key.nvim/issues/589)) ([a7ced9f](https://github.com/folke/which-key.nvim/commit/a7ced9f00a309418865ec2e3c272113147d167fe))
* which-key now requires Neovim &gt;= 0.9 ([53ba0ac](https://github.com/folke/which-key.nvim/commit/53ba0accc2d607ef3f2b4f6e40aa9ac75e611dee))


### Bug Fixes

* **ignore_missing:** not showing key maps with desc field ([#577](https://github.com/folke/which-key.nvim/issues/577)) ([928c6c8](https://github.com/folke/which-key.nvim/commit/928c6c8fb62df55fa640399b7d76410c037b5f55))
* **is_enabled:** disable whichkey in cmdline-window ([#581](https://github.com/folke/which-key.nvim/issues/581)) ([26ff0e6](https://github.com/folke/which-key.nvim/commit/26ff0e6084a4e957fc13ffe00bafd7c0c5ab81cc))
* **keys:** fix buffer-local mapping groups ([d87c01c](https://github.com/folke/which-key.nvim/commit/d87c01c9bbcc7c1c2d248dca1b11285259d66be8))
* **mappings:** dont remove desc ([4a7d732](https://github.com/folke/which-key.nvim/commit/4a7d7328b26d3f3355a43af4d8dc5ffd33cbd793))

## [1.6.1](https://github.com/folke/which-key.nvim/compare/v1.6.0...v1.6.1) (2024-05-31)


### Bug Fixes

* **reg:** Added check for OSC 52 to disable related register previews ([#604](https://github.com/folke/which-key.nvim/issues/604)) ([8063a7f](https://github.com/folke/which-key.nvim/commit/8063a7f33bfea6a6387907c93a30a5877aa02633))
* small typo in operator description ([#528](https://github.com/folke/which-key.nvim/issues/528)) ([d65087b](https://github.com/folke/which-key.nvim/commit/d65087b892c45d3722b6511c83a029671d6290e5))

## [1.6.0](https://github.com/folke/which-key.nvim/compare/v1.5.1...v1.6.0) (2023-10-17)


### Features

* **presets:** added gt and gT. Fixes [#457](https://github.com/folke/which-key.nvim/issues/457) ([3ba77f0](https://github.com/folke/which-key.nvim/commit/3ba77f0b0961b3fe685397b8d8f34f231b9350a6))


### Bug Fixes

* call config in issue template ([#489](https://github.com/folke/which-key.nvim/issues/489)) ([09a8188](https://github.com/folke/which-key.nvim/commit/09a8188224dc890618dfbc961436b106d912c2c1))
* **view:** set modifiable flag for view buffer ([#506](https://github.com/folke/which-key.nvim/issues/506)) ([1d17760](https://github.com/folke/which-key.nvim/commit/1d1776012eda4258985f6f1f0c02b78594a3f37b))

## [1.5.1](https://github.com/folke/which-key.nvim/compare/v1.5.0...v1.5.1) (2023-07-15)


### Bug Fixes

* revert: never overwrite actual keymaps with group names. Fixes [#478](https://github.com/folke/which-key.nvim/issues/478) Fixes [#479](https://github.com/folke/which-key.nvim/issues/479) Fixes [#480](https://github.com/folke/which-key.nvim/issues/480) ([fc25407](https://github.com/folke/which-key.nvim/commit/fc25407a360d27c36a30a90ff36861aa20ef2e54))

## [1.5.0](https://github.com/folke/which-key.nvim/compare/v1.4.3...v1.5.0) (2023-07-14)


### Features

* **marks:** show filename as label when no label ([25babc6](https://github.com/folke/which-key.nvim/commit/25babc6add21c17d6391a585302aee5632266622))


### Bug Fixes

* **keys:** don't show empty groups ([8503c0d](https://github.com/folke/which-key.nvim/commit/8503c0d725420b37ac31e44753657cde91435597))
* never overwrite actual keymaps with group names ([f61da3a](https://github.com/folke/which-key.nvim/commit/f61da3a3a6143b7a42b4b16e983004856ec26bd1))
* **registers:** dont trigger on @. Fixes [#466](https://github.com/folke/which-key.nvim/issues/466) ([65b36cc](https://github.com/folke/which-key.nvim/commit/65b36cc258e857dea92fc11cdc0d6e2bb01d3e87))

## [1.4.3](https://github.com/folke/which-key.nvim/compare/v1.4.2...v1.4.3) (2023-05-22)


### Bug Fixes

* **health:** dont show duplicates between global and buffer-local. It's too confusing ([015fdf3](https://github.com/folke/which-key.nvim/commit/015fdf3e3e052d4a9fee997ca0aa387c2dd3731c))

## [1.4.2](https://github.com/folke/which-key.nvim/compare/v1.4.1...v1.4.2) (2023-05-10)


### Bug Fixes

* **health:** update the deprecated function ([#453](https://github.com/folke/which-key.nvim/issues/453)) ([12d3b11](https://github.com/folke/which-key.nvim/commit/12d3b11a67b94d65483f10c6ba0a47474039543a))

## [1.4.1](https://github.com/folke/which-key.nvim/compare/v1.4.0...v1.4.1) (2023-05-04)


### Bug Fixes

* **keys:** dont overwrite existing keymaps with a callback. Fixes [#449](https://github.com/folke/which-key.nvim/issues/449) ([4db6bb0](https://github.com/folke/which-key.nvim/commit/4db6bb080b269ac155e5aa1696d26f2376c749ab))

## [1.4.0](https://github.com/folke/which-key.nvim/compare/v1.3.0...v1.4.0) (2023-04-18)


### Features

* **view:** ensure it's above other floating windows ([#442](https://github.com/folke/which-key.nvim/issues/442)) ([9443778](https://github.com/folke/which-key.nvim/commit/94437786a0d0fde61284f8476ac142896878c2d7))

## [1.3.0](https://github.com/folke/which-key.nvim/compare/v1.2.3...v1.3.0) (2023-04-17)


### Features

* **health:** move health check to separate health file ([b56c512](https://github.com/folke/which-key.nvim/commit/b56c5126752fcd498a81c6d8d1e7f51f251166eb))
* **preset:** add `z&lt;CR&gt;` preset ([#346](https://github.com/folke/which-key.nvim/issues/346)) ([ed37330](https://github.com/folke/which-key.nvim/commit/ed3733059ffa281c8144e44f1b4819a771ddf4de))
* **preset:** added `zi` and `CTRL-W_o` ([#378](https://github.com/folke/which-key.nvim/issues/378)) ([5e8e6b1](https://github.com/folke/which-key.nvim/commit/5e8e6b1c70d3fcbe2712453ef3ebbf07d0d2aff4))
* **view:** allow percentages for margins. Fixes [#436](https://github.com/folke/which-key.nvim/issues/436) ([0b5a653](https://github.com/folke/which-key.nvim/commit/0b5a6537b66ee37d03c6c3f0e21fd147f817422d))


### Bug Fixes

* **health:** add OK output to check_health fn ([#375](https://github.com/folke/which-key.nvim/issues/375)) ([c9c430a](https://github.com/folke/which-key.nvim/commit/c9c430ab19a3bf8dd394dd9925a3a219063276b9))
* **keys:** allow keymap desc to override preset labels. Fixes [#386](https://github.com/folke/which-key.nvim/issues/386) ([6aa1b2f](https://github.com/folke/which-key.nvim/commit/6aa1b2fa93a2a26a1bd752080ec6a51beb009e75))
* **tree:** don't cache plugin nodes. Fixes [#441](https://github.com/folke/which-key.nvim/issues/441) ([20fcd7b](https://github.com/folke/which-key.nvim/commit/20fcd7b602a2c58d634eaa1f1d28b16a6acbfad3))
* **util:** clear cache when leader changes ([df3597f](https://github.com/folke/which-key.nvim/commit/df3597f7dc0f379bda865e3c9dd6303fa6e4c959))
* **util:** missing return statement ([f6bb21c](https://github.com/folke/which-key.nvim/commit/f6bb21c8c1d72008783466e80e0c993ef056a3a9))
* **util:** nil check ([6ab25e2](https://github.com/folke/which-key.nvim/commit/6ab25e24ec2b2a8fb88f43eb13feb21e5042c280))


### Performance Improvements

* **keys:** optimized `update_keymaps` ([476d137](https://github.com/folke/which-key.nvim/commit/476d13754db0da7831fc3581fb243cd7f0d3e581))
* **tree:** added fast nodes lookup ([8e5e012](https://github.com/folke/which-key.nvim/commit/8e5e0126aaff9bd73eb25a6d5568f6b5bdff58f0))
* **util:** cache parse_keys ([8649bf5](https://github.com/folke/which-key.nvim/commit/8649bf5c66b8fa1fa6ee879b9af78e89f886d13c))
* **util:** cache replace termcodes ([eaa8027](https://github.com/folke/which-key.nvim/commit/eaa80272ef488c68cd51698c64e795767c6e0624))

## [1.2.3](https://github.com/folke/which-key.nvim/compare/v1.2.2...v1.2.3) (2023-04-17)


### Bug Fixes

* **util:** dont parse empty lhs ([8d5ab76](https://github.com/folke/which-key.nvim/commit/8d5ab76836d89be1c761a4ed61bf700d98c71e5d))
* **util:** only collect valid &lt;&gt; keys ([#438](https://github.com/folke/which-key.nvim/issues/438)) ([4bd6dca](https://github.com/folke/which-key.nvim/commit/4bd6dcaa6d7e1650590303f0066d32aa6762d8f3))
* **util:** replace `&lt;lt&gt;` by `<` before parsing ([789ac71](https://github.com/folke/which-key.nvim/commit/789ac718ee7a2b49dd82409e3d7cf45b52ea95ce))
* **view:** allow deviating paddings per side ([#400](https://github.com/folke/which-key.nvim/issues/400)) ([3090eaf](https://github.com/folke/which-key.nvim/commit/3090eafb780da76eb4876986081551db80bf35cd))


### Performance Improvements

* **util:** simplify and optimize parsers ([#435](https://github.com/folke/which-key.nvim/issues/435)) ([b0ebb67](https://github.com/folke/which-key.nvim/commit/b0ebb6722c77dda1ab1e3ce13521fe7db20cbc79))

## [1.2.2](https://github.com/folke/which-key.nvim/compare/v1.2.1...v1.2.2) (2023-04-16)


### Performance Improvements

* **mappings:** avoid computing error string on hot path ([#429](https://github.com/folke/which-key.nvim/issues/429)) ([6892f16](https://github.com/folke/which-key.nvim/commit/6892f165bb984561f8cac298a6747da338d04668))

## [1.2.1](https://github.com/folke/which-key.nvim/compare/v1.2.0...v1.2.1) (2023-03-26)


### Bug Fixes

* **icons:** fixed obsolete icons with nerdfix ([151f21d](https://github.com/folke/which-key.nvim/commit/151f21d34d50fc53506ddc9d8ec58234202df795))
* **view:** wrong window position when statusline is not set ([#363](https://github.com/folke/which-key.nvim/issues/363)) ([e14f8dc](https://github.com/folke/which-key.nvim/commit/e14f8dc6304e774ce005d09f7feebbd191fe20f9))

## [1.2.0](https://github.com/folke/which-key.nvim/compare/v1.1.1...v1.2.0) (2023-03-01)


### Features

* enable spelling plugin by default ([6d886f4](https://github.com/folke/which-key.nvim/commit/6d886f4dcaa25d1fe20e332f779fe1edb726d063))
* make delay configurable for marks/registers/spelling. Fixes [#379](https://github.com/folke/which-key.nvim/issues/379). Fixes [#152](https://github.com/folke/which-key.nvim/issues/152), Fixes [#220](https://github.com/folke/which-key.nvim/issues/220), Fixes [#334](https://github.com/folke/which-key.nvim/issues/334) ([5649320](https://github.com/folke/which-key.nvim/commit/56493205745597abdd8d3ceb22f502ffe74784f5))

## [1.1.1](https://github.com/folke/which-key.nvim/compare/v1.1.0...v1.1.1) (2023-02-10)


### Bug Fixes

* remove duplicate kaymap ([#361](https://github.com/folke/which-key.nvim/issues/361)) ([9a4680e](https://github.com/folke/which-key.nvim/commit/9a4680e95b7026c58f0a377de0f13ee2507ece7a))

## [1.1.0](https://github.com/folke/which-key.nvim/compare/v1.0.0...v1.1.0) (2023-01-10)


### Features

* Hide mapping when `desc = "which_key_ignore"` ([#391](https://github.com/folke/which-key.nvim/issues/391)) ([fd07b61](https://github.com/folke/which-key.nvim/commit/fd07b6137f1e362a66df04f7c7055b99319e3a4d))


### Bug Fixes

* visual-multi compatibility ([#389](https://github.com/folke/which-key.nvim/issues/389)) ([#385](https://github.com/folke/which-key.nvim/issues/385)) ([01334bb](https://github.com/folke/which-key.nvim/commit/01334bb48c53231fc8b2e2932215bfee05474904))

## 1.0.0 (2023-01-04)


### Features

* add &lt;C-w&gt;_ to misc ([#296](https://github.com/folke/which-key.nvim/issues/296)) ([03b8c1d](https://github.com/folke/which-key.nvim/commit/03b8c1dde8c02f187869c56a6019d5e2578f7af7))
* add preset key to mappings for API usage ([ed7d6c5](https://github.com/folke/which-key.nvim/commit/ed7d6c523ae8ef7b8059d2fee0836009e71bcd0c))
* added a winblend option for the floating window ([#161](https://github.com/folke/which-key.nvim/issues/161)) ([d3032b6](https://github.com/folke/which-key.nvim/commit/d3032b6d3e0adb667975170f626cb693bfc66baa))
* added duplicate mapping checks to checkhealth [#34](https://github.com/folke/which-key.nvim/issues/34) ([710c5f8](https://github.com/folke/which-key.nvim/commit/710c5f81da2c34e6e0f361d87cfca27207e1b994))
* added healthcheck to check for conflicting keymaps ([44d3c3f](https://github.com/folke/which-key.nvim/commit/44d3c3f9307930ce8c877383d51fca1a353982d8))
* added ignore_missing option to hide any keymap for which no label exists [#60](https://github.com/folke/which-key.nvim/issues/60) ([1ccba9d](https://github.com/folke/which-key.nvim/commit/1ccba9d0b553b08feaca9f432386f9c33bd1656f))
* added operators plugin ([c7f8496](https://github.com/folke/which-key.nvim/commit/c7f84968e44f1a9ab9687ddf0b3dc5465e48bc75))
* added option to configure scroll bindings inside the popup ([#175](https://github.com/folke/which-key.nvim/issues/175)) ([a54ef5f](https://github.com/folke/which-key.nvim/commit/a54ef5f5db5819ee65a5ec3dea9bae64476c5017))
* added options to align columns left, center or right [#82](https://github.com/folke/which-key.nvim/issues/82) ([2467fb1](https://github.com/folke/which-key.nvim/commit/2467fb15e8775928fba3d7d20a68b64852f44122))
* added settings to disable the WhichKey popup for certain buftypes and filetyes ([fb276a0](https://github.com/folke/which-key.nvim/commit/fb276a07c7dc305e48ecc2683e4bd28cda49499a))
* added support for expr mappings ([9d2785c](https://github.com/folke/which-key.nvim/commit/9d2785c4d44b4a8ca1095856cb4ee34a32497cf6))
* added triggers_blacklist to blacklist certain whichkey hooks [#73](https://github.com/folke/which-key.nvim/issues/73) ([ec1474b](https://github.com/folke/which-key.nvim/commit/ec1474bb0c373eb583962deff20860c2af54f932))
* added WhichKeyBorder highlight group ([9c190ea](https://github.com/folke/which-key.nvim/commit/9c190ea91939eba8c2d45660127e0403a5300b5a))
* allow functions to be passed to create keybindings. Implements [#31](https://github.com/folke/which-key.nvim/issues/31) ([cf644cd](https://github.com/folke/which-key.nvim/commit/cf644cd9a0e989ad3e0a6dffb98beced742f3297))
* allow manual setup of triggers [#30](https://github.com/folke/which-key.nvim/issues/30) ([423a50c](https://github.com/folke/which-key.nvim/commit/423a50cccfeb8b812e0e89f156316a4bd9d2673a))
* allow mapping to have multiple modes as a table ([0d559fa](https://github.com/folke/which-key.nvim/commit/0d559fa5573aa48c4822e8874315316bd075e17e))
* allow mode to be set on a single mapping ([2a08d58](https://github.com/folke/which-key.nvim/commit/2a08d58658e1de0fae3b44e21e8ed72399465701))
* allow overriding key labels [#77](https://github.com/folke/which-key.nvim/issues/77) ([2be929e](https://github.com/folke/which-key.nvim/commit/2be929e34b2f2b982e6b978c0bd94cd2e1d500e6))
* allow to close popup with &lt;c-c&gt; [#33](https://github.com/folke/which-key.nvim/issues/33) ([410523a](https://github.com/folke/which-key.nvim/commit/410523a6d7bcbcab73f8c7b0fc567893d7cd8c44))
* better logging ([c39df95](https://github.com/folke/which-key.nvim/commit/c39df95881a6cd8ac27fce5926dc2dc1b4597df9))
* better support for plugin actions with custom lua function ([222a8ee](https://github.com/folke/which-key.nvim/commit/222a8eeaf727f9b1b767424198f7c71274c04d43))
* builtin key mappings ([0063ceb](https://github.com/folke/which-key.nvim/commit/0063ceb161475097885d567500fe764358983c62))
* check for rogue existsing WhichKey mappings and show error. WK handles triggers automatically, no need to define them ([db97a30](https://github.com/folke/which-key.nvim/commit/db97a301fb7691b61cd6c975e3cc060fb53fd980))
* easily reset WK with plenary for development of WK ([55b4dab](https://github.com/folke/which-key.nvim/commit/55b4dabab649d59e657917eb17c9d57716817719))
* expose registers to customize order ([2b83fe7](https://github.com/folke/which-key.nvim/commit/2b83fe74dee00763e4c037d198c88ff11c843914))
* for nvim 0.7.0 or higher, use native keymap callbacks instead of which key functions ([5e96cf9](https://github.com/folke/which-key.nvim/commit/5e96cf950a864a4600512c90f2080b0b6f0eacb7))
* group symbol ([5e02b66](https://github.com/folke/which-key.nvim/commit/5e02b66b9e7add373967b798552a7cc9a427efb4))
* handle [count] with motion. Implements [#11](https://github.com/folke/which-key.nvim/issues/11) ([d93ef0f](https://github.com/folke/which-key.nvim/commit/d93ef0f2f1a9a6288016a3a82f70399e350a574f))
* hide mapping boilerplate ([#6](https://github.com/folke/which-key.nvim/issues/6)) ([b3357de](https://github.com/folke/which-key.nvim/commit/b3357de005f27a3cc6aabe922e8ee308470d9343))
* honor timeoutlen when typing an operator followed by i or a instead of showing immediately ([54d1b3a](https://github.com/folke/which-key.nvim/commit/54d1b3ab3ed9132142f2139964cfa68d018b38c5))
* initial commit ([970e79f](https://github.com/folke/which-key.nvim/commit/970e79f7016f6cc2a89dad8c50e2e89657684f55))
* keyamp functions ([801cc81](https://github.com/folke/which-key.nvim/commit/801cc810f4d57eca029261f383b2483ec21e5824))
* make custom operators configurable (fixes [#9](https://github.com/folke/which-key.nvim/issues/9)) ([81875d8](https://github.com/folke/which-key.nvim/commit/81875d875f7428c7a087e0d051744c7b3f9dc1b3))
* make help message configurable ([7b1c6aa](https://github.com/folke/which-key.nvim/commit/7b1c6aa23061a9ed1acdfec3d20dc5e361ec01a3))
* Make keypress message configuratble ([#351](https://github.com/folke/which-key.nvim/issues/351)) ([fd2422f](https://github.com/folke/which-key.nvim/commit/fd2422fb7030510cf9c3304047e653e8adcd8f20))
* motions plugin ([f989fcf](https://github.com/folke/which-key.nvim/commit/f989fcfeafd4fd333a8e87617fce39a449ae81ca))
* new keymap dsl ([#352](https://github.com/folke/which-key.nvim/issues/352)) Docs to come ([fbf0381](https://github.com/folke/which-key.nvim/commit/fbf038110edb5e2cbecaac57570aae2c9fa2939c))
* option to make some triggers show immediately, regardless of timeoutlen ([3a52dc0](https://github.com/folke/which-key.nvim/commit/3a52dc02b6e542d5cd216381ccfa108943bab17c))
* plugin for registers ([5415832](https://github.com/folke/which-key.nvim/commit/541583280fab4ea96900f35fb6b5ffb8de103a4c))
* plugin support + first builtin marks plugin ([9d5e631](https://github.com/folke/which-key.nvim/commit/9d5e6311c20970741eaaf7a3950c1a33de5eedaa))
* prefer `desc` to `cmd` as the fallback label ([#253](https://github.com/folke/which-key.nvim/issues/253)) ([bd4411a](https://github.com/folke/which-key.nvim/commit/bd4411a2ed4dd8bb69c125e339d837028a6eea71))
* preset with misc keybindings ([e610338](https://github.com/folke/which-key.nvim/commit/e61033858b8d5208a49c24d70eb9576cbd22e887))
* set keymap desc when creating new mappings based on the WhichKey labels ([f4518ca](https://github.com/folke/which-key.nvim/commit/f4518ca50193a545681ba65ba0c5bb8a8479c5b5))
* set popup filetype to WhichKey and buftype to nofile [#86](https://github.com/folke/which-key.nvim/issues/86) ([20682f1](https://github.com/folke/which-key.nvim/commit/20682f189a0c452203f6365f66eccb0407b20936))
* show a warning if &lt;leader&gt; is already mapped, even if it's <nop> ([ac56f45](https://github.com/folke/which-key.nvim/commit/ac56f45095e414c820f621423611aac4027f74bd))
* show breadcrumb and help on command line ([c27535c](https://github.com/folke/which-key.nvim/commit/c27535ca085c05ade1e23b3b347e39e53c24d33a))
* show keys and help in float when cmdheight == 0 ([f645017](https://github.com/folke/which-key.nvim/commit/f64501787bebe9ff28c10dbe470ffad5dd017769))
* show/hide a fake cursor when WK is open ([0f53f40](https://github.com/folke/which-key.nvim/commit/0f53f40c1b827d35771c82a5c47c5a54d9408f7c))
* spelling suggestion plugin ([4b74f21](https://github.com/folke/which-key.nvim/commit/4b74f218f4541991a40719286f96cce9447a89c4))
* support for custom text object completion. Fixes [#10](https://github.com/folke/which-key.nvim/issues/10) ([394ff5a](https://github.com/folke/which-key.nvim/commit/394ff5a37bab051857de4216ee25db2284de2196))
* support opts.remap for keymap ([#339](https://github.com/folke/which-key.nvim/issues/339)) ([6885b66](https://github.com/folke/which-key.nvim/commit/6885b669523ff4238de99a7c653d47b081b5506d))
* support using lua function for expr ([#110](https://github.com/folke/which-key.nvim/issues/110)) ([e0dce15](https://github.com/folke/which-key.nvim/commit/e0dce1552ea37964ae6ac7144709867544eae7f3))
* text objects ([d255b71](https://github.com/folke/which-key.nvim/commit/d255b71992494ce4998caae7fe281144fb669abb))
* WhichKey vim command to show arbitrary keymaps ([df615d4](https://github.com/folke/which-key.nvim/commit/df615d44987a8bfe8910c618164f696e227ecfd4))


### Bug Fixes

* :norm .. commands keep feeding &lt;esc&gt; at the end of the command [#58](https://github.com/folke/which-key.nvim/issues/58) ([d66ffdd](https://github.com/folke/which-key.nvim/commit/d66ffdd5a845c713f581ac6da36173e88096e0fa))
* add delay option to macro key ([#152](https://github.com/folke/which-key.nvim/issues/152)) ([#156](https://github.com/folke/which-key.nvim/issues/156)) ([bd226c4](https://github.com/folke/which-key.nvim/commit/bd226c4d02d7f360747364a59cc5f0da50524f2c))
* add remaining &lt;esc&gt; to pending in case there's no other characters ([29a82b5](https://github.com/folke/which-key.nvim/commit/29a82b575b9752a45b005327030948ce8cb513a0))
* add triggers for other modes in marks and register plugin ([#116](https://github.com/folke/which-key.nvim/issues/116)) ([bbfc640](https://github.com/folke/which-key.nvim/commit/bbfc640c44612d705f4b0670ec1387c8a6ff2c7c))
* added @ trigger for showing registers ([01b6676](https://github.com/folke/which-key.nvim/commit/01b66769480fac14f6efa7c31327234398d05837))
* added builtin plugins to config ([6e461ca](https://github.com/folke/which-key.nvim/commit/6e461caec3d3aa43f1fa2b7890b299705bccfe8d))
* added hidden option to disable the popup on motion counts (motions.count) ([ea975ef](https://github.com/folke/which-key.nvim/commit/ea975ef254f10c4938cd663a7c4fb14e2d7514c0))
* added support for operator pending keymaps ([1f6b510](https://github.com/folke/which-key.nvim/commit/1f6b510f6ef0c223b51f3599200bbf6abc30f909))
* added z= for spelling correction ([59603de](https://github.com/folke/which-key.nvim/commit/59603dee2f67f623a520148d60c634f6f56f6017))
* always escape &lt;leader&gt; when it's a backslash ([41636a3](https://github.com/folke/which-key.nvim/commit/41636a3be909af5d20d811f8ce6a304a5ee3cc21))
* always execute keys with remap, but unhook / hook WK triggers (Fixes [#8](https://github.com/folke/which-key.nvim/issues/8)) ([bf329df](https://github.com/folke/which-key.nvim/commit/bf329df0ee11d6c80c7208b40eab74368e963245))
* always map &lt;leader&gt;, even without register ([512631c](https://github.com/folke/which-key.nvim/commit/512631c1bdce96dd048115cb139ea3a8452a931a))
* always unhook and ignore errors ([01a60cd](https://github.com/folke/which-key.nvim/commit/01a60cd5929b395042c8ba3d872f6f25ccd55ecb))
* always use noremap=false for &lt;plug&gt; commands ([9b9cece](https://github.com/folke/which-key.nvim/commit/9b9cece006b78ff7527a35285a4b5c1359d70fd8))
* always use word under the cursor for spelling suggestions ([c5b19ec](https://github.com/folke/which-key.nvim/commit/c5b19ecf4d1d8f8c77ee982caf9792740f6d5e53))
* better handling of weird norm and getchar endless &lt;esc&gt; bug [#68](https://github.com/folke/which-key.nvim/issues/68) ([bfd37e9](https://github.com/folke/which-key.nvim/commit/bfd37e93761d622328c673828b537d5671389413))
* better sorting ([99e8940](https://github.com/folke/which-key.nvim/commit/99e894032afbe2543dbbf9bba05518d96b852aa0))
* center alignemnt should be an integer ([db85198](https://github.com/folke/which-key.nvim/commit/db851981595fc360e9b6196a7c3995611aceac3b))
* check for FloatBorder before setting winhighlight ([af6b91d](https://github.com/folke/which-key.nvim/commit/af6b91dc09e4ed830d8cd4a3652a5b3f80ccefac))
* check is hook exists before unhooking ([f6cf3a2](https://github.com/folke/which-key.nvim/commit/f6cf3a2e49c09aba739c0f6fc85d3aebf2b96cb6))
* cmd can be nil ([060a574](https://github.com/folke/which-key.nvim/commit/060a574c228433e9b17960fa0eafca0a975381e8))
* **colors:** Separator links to DiffAdd ([#302](https://github.com/folke/which-key.nvim/issues/302)) ([a2749c5](https://github.com/folke/which-key.nvim/commit/a2749c5b039ad34734c98f8752b9fb5da7ceac55))
* Compatibility with Visual Multi plug ([#278](https://github.com/folke/which-key.nvim/issues/278)) ([92916b6](https://github.com/folke/which-key.nvim/commit/92916b6cede0ffd7d5c1ce9abad93ec0c4d9635e))
* convert trings with strtrans to properly render non printable characters ([d85ce36](https://github.com/folke/which-key.nvim/commit/d85ce3627f4060f622e4c0a9657f26c0151829de))
* correct floating window position in Neovim 0.6 nightly ([#176](https://github.com/folke/which-key.nvim/issues/176)) ([a35a910](https://github.com/folke/which-key.nvim/commit/a35a910d28683294fd23d35dd03c06f6f7c37b17))
* correctly handle counts before commands [#17](https://github.com/folke/which-key.nvim/issues/17) ([4feb319](https://github.com/folke/which-key.nvim/commit/4feb319ff89fb8659efa2a788f808bc390afa490))
* correctly unhook buffer local mappings before executing keys ([4f98b47](https://github.com/folke/which-key.nvim/commit/4f98b4713ea9d4534662ceb7b542b0626eeb9ea8))
* disable folding on whichkey popup. Fixes [#99](https://github.com/folke/which-key.nvim/issues/99) ([78821de](https://github.com/folke/which-key.nvim/commit/78821de0b633275d6934660e67989639bc7a784c))
* disable operator pending maps for now ([#2](https://github.com/folke/which-key.nvim/issues/2)) ([0cd66a8](https://github.com/folke/which-key.nvim/commit/0cd66a84520fc0e7e3eec81f081157541cb48dbd))
* do feedkeys in correct mode when dealing with operator pending commands. Fixes [#8](https://github.com/folke/which-key.nvim/issues/8) ([cf30788](https://github.com/folke/which-key.nvim/commit/cf307886b68ed53334ffdcee809a751376269e33))
* don't show &lt;esc&gt; mappings since <esc> closes the popup ([09db756](https://github.com/folke/which-key.nvim/commit/09db756b5d357767a635a4d169e2e820b2962ea8))
* don't show spelling when the command was started with a count [#80](https://github.com/folke/which-key.nvim/issues/80) ([20a85bd](https://github.com/folke/which-key.nvim/commit/20a85bd8bc54a11cf040aafa5d60f8a735eecfbd))
* dont do feedkeys when user uses WhichKey command with non existing prefix ([f9537ce](https://github.com/folke/which-key.nvim/commit/f9537ce0f7457665e3b90d82c5f3f2c37fe0506f))
* dont pass zero counts ([0c3cfb0](https://github.com/folke/which-key.nvim/commit/0c3cfb0064ceec5b182bac580033e0654d9575e6))
* dont show errors about loading order of setup and register ([2adbc17](https://github.com/folke/which-key.nvim/commit/2adbc17e00061073f2c2a40b6420ee2a80ea458d))
* explicitely check if we try to execute an auto which-key mapping. shouldn't happen, but still safer to check ([30fdd46](https://github.com/folke/which-key.nvim/commit/30fdd465433d48cab3b1f894daf52fa0005cf7ac))
* expose presets so one can change them if needed [#70](https://github.com/folke/which-key.nvim/issues/70) ([46ea686](https://github.com/folke/which-key.nvim/commit/46ea686c6cc9bfc96bc492c76a76d43548a587c4))
* feed CTRL-O again if called from CTRL-O ([#145](https://github.com/folke/which-key.nvim/issues/145)) ([833b5ea](https://github.com/folke/which-key.nvim/commit/833b5ea1a0d4b3bddf4b5c68fc89f1234960edec))
* feed the keys as typed ([#333](https://github.com/folke/which-key.nvim/issues/333)) ([33b4e72](https://github.com/folke/which-key.nvim/commit/33b4e72a07546bc4798b4bafb99ae06df47bd790))
* fix flickering on tmux ([f112602](https://github.com/folke/which-key.nvim/commit/f11260251ad942ba1635db9bc25c2efaf75caf0a))
* fix issue when cmdheight=0 [#301](https://github.com/folke/which-key.nvim/issues/301) ([#305](https://github.com/folke/which-key.nvim/issues/305)) ([9cd09ca](https://github.com/folke/which-key.nvim/commit/9cd09ca6bbe5acfbce86ca023fdc720f6aa132d6))
* fixed 0 after an operator. Wrongly assumed any number to be a count for following op mode, but not the case for 0 [#59](https://github.com/folke/which-key.nvim/issues/59) [#61](https://github.com/folke/which-key.nvim/issues/61) ([36616ca](https://github.com/folke/which-key.nvim/commit/36616cacba5d9eb716017bf23b7bbbe4cb4a6822))
* fixed possible nil error when showing marks ([b44fc09](https://github.com/folke/which-key.nvim/commit/b44fc095f6d0144278f3413533ad2d40ae664229))
* for sporadic loss of lua function for mapping ([#216](https://github.com/folke/which-key.nvim/issues/216)) ([312c386](https://github.com/folke/which-key.nvim/commit/312c386ee0eafc925c27869d2be9c11ebdb807eb))
* formatting of text-objects plugin ([442d2d3](https://github.com/folke/which-key.nvim/commit/442d2d383284390c5ee1b922036fc10fff530b2d))
* get value of register '=' with getreg('=',1) ([#114](https://github.com/folke/which-key.nvim/issues/114)) ([6224ea8](https://github.com/folke/which-key.nvim/commit/6224ea81f505c66a9644f89129149b108f722e56))
* handle backslash as localleader [#47](https://github.com/folke/which-key.nvim/issues/47) ([cd23fdc](https://github.com/folke/which-key.nvim/commit/cd23fdc1b0cbdb22769bed5cb275a6d1c4bd9bfc))
* handle baskslashes when leader or localleader isn't set ([d155ab3](https://github.com/folke/which-key.nvim/commit/d155ab3bef11a8156995b47d5552586e5c9f66a3))
* handle keymaps with a &lt;nop&gt; rhs as non existing and possibly overwrite them with WK hooks [#35](https://github.com/folke/which-key.nvim/issues/35) ([402be18](https://github.com/folke/which-key.nvim/commit/402be18dc656897b1dc68c88fab4ffe8635b8209))
* handle nvim_{buf_}get_keymap return no rhs due to 'callback' mapping ([#223](https://github.com/folke/which-key.nvim/issues/223)) ([28d2bd1](https://github.com/folke/which-key.nvim/commit/28d2bd129575b5e9ebddd88506601290bb2bb221))
* handle possible errors when getting last expression register [#64](https://github.com/folke/which-key.nvim/issues/64) ([7a1be6f](https://github.com/folke/which-key.nvim/commit/7a1be6ff950c7fb94a4f9e9bdb428a514e569503))
* highlighting of line number in marks ([9997d93](https://github.com/folke/which-key.nvim/commit/9997d93e5adcf0352aa73c42d3c395ba775600e9))
* immediately show registers and marks. Fixes [#144](https://github.com/folke/which-key.nvim/issues/144) ([653ce71](https://github.com/folke/which-key.nvim/commit/653ce711e6c27416ac79c4811ff814e9a38fddcf))
* link default WhichKeyBorder to FloatBorder. Fixes [#331](https://github.com/folke/which-key.nvim/issues/331) ([1698d6d](https://github.com/folke/which-key.nvim/commit/1698d6d0ff0b00b8499d9aea8715d120dc526900))
* make register selection work in INSERT mode ([d4315f8](https://github.com/folke/which-key.nvim/commit/d4315f8991da816c30e9387a891c02774552dc36))
* make spelling suggestions also work for correctly spelled words ([d02dc34](https://github.com/folke/which-key.nvim/commit/d02dc344bdaf273dfde7672f3f8e70a307593f62))
* make sure we never accidentally show WK triggers ([197b4d3](https://github.com/folke/which-key.nvim/commit/197b4d3403c04c0045e8d541e8cd2504aba5f168))
* make which-key's lazy loading work when it is also lazy-loaded ([7d929b9](https://github.com/folke/which-key.nvim/commit/7d929b96e2588fe9710ad795402eaead1aa0f70f))
* manual command now uses proper escaping for prefix ([334fcca](https://github.com/folke/which-key.nvim/commit/334fcca64611dbca8c0c669260f4fb2a8ff81509))
* mapleader=\ ([b5c8985](https://github.com/folke/which-key.nvim/commit/b5c89851d580459c1dd33ecbda611ae06e22eec4))
* mapping when right-hand side is `nil` ([#323](https://github.com/folke/which-key.nvim/issues/323)) ([1d449d4](https://github.com/folke/which-key.nvim/commit/1d449d44e01787ef17dc7b0672eec01a8121b36e))
* never hook in SELECT mode and properly handle v, x, s [#45](https://github.com/folke/which-key.nvim/issues/45) [#46](https://github.com/folke/which-key.nvim/issues/46) ([2844e1c](https://github.com/folke/which-key.nvim/commit/2844e1cbf298129afa58c13a90f91be907232dbf))
* never hook j and k in INSERT mode automatcally to prevent jk kj &lt;ESC&gt; mappings to work as intended ([9a2faed](https://github.com/folke/which-key.nvim/commit/9a2faed055459d3226634344468f78bf85d77fa8))
* never hook numbers. locks up due to v:count. Fixes [#118](https://github.com/folke/which-key.nvim/issues/118) ([2d2954a](https://github.com/folke/which-key.nvim/commit/2d2954a1d05b4f074e022e64db9aa6093d439bb0))
* never hook on &lt;esc&gt; ([fd08322](https://github.com/folke/which-key.nvim/commit/fd0832233bd0c733618fab1c3df92f261c13d6b3))
* never hook q [#63](https://github.com/folke/which-key.nvim/issues/63) ([95ae9d2](https://github.com/folke/which-key.nvim/commit/95ae9d2d00e8714379e64994e69ae17fc540a7d6))
* never hook to operators in visual mode [#61](https://github.com/folke/which-key.nvim/issues/61) ([43d799a](https://github.com/folke/which-key.nvim/commit/43d799ad0e6218964e802ff342ca5f9352105175))
* nil in health check ([5c018ae](https://github.com/folke/which-key.nvim/commit/5c018ae412b235abe17e24b46057564db0944dc4))
* nvim_win_close force = true ([ca73a0e](https://github.com/folke/which-key.nvim/commit/ca73a0e03f142067a16891b712c7ea73ac646dff))
* nvim-0.7.0 check ([#338](https://github.com/folke/which-key.nvim/issues/338)) ([1491c35](https://github.com/folke/which-key.nvim/commit/1491c355ec9bb0ec4c8e71c8625bc5f55a54b925))
* only create mappings for builtin operators. plugings will always have their own mappings ([1b2ec76](https://github.com/folke/which-key.nvim/commit/1b2ec760d65ce9eda473879bec5c31c4771079e7))
* only enable plugins that are specified in the configuration ([b8ed0e8](https://github.com/folke/which-key.nvim/commit/b8ed0e8e675b747ce21aa830c38ddf4fb2458e05))
* only show message about existing &lt;leader&gt; mapping in NORMAL mode [#75](https://github.com/folke/which-key.nvim/issues/75) ([bcc8297](https://github.com/folke/which-key.nvim/commit/bcc829775b7d366f61bd2db1753e2c6b3d1ec4d3))
* only show up/down when scrolling is posible (fixes [#4](https://github.com/folke/which-key.nvim/issues/4)) ([9e7986d](https://github.com/folke/which-key.nvim/commit/9e7986d8726291ee93ef448ae8c452981f1fc75f))
* override &lt;leader&gt; if it's mapped to <nop> ([928288b](https://github.com/folke/which-key.nvim/commit/928288b543d77c38ade936ee8bdef32a769ebe3a))
* pass + and * regsiters to feedkeys [#36](https://github.com/folke/which-key.nvim/issues/36) ([ce37f41](https://github.com/folke/which-key.nvim/commit/ce37f41641edb90bf51b975999553d13961ed8fa))
* pass 0 instead of nil for current buffer ([#227](https://github.com/folke/which-key.nvim/issues/227)) ([387fd67](https://github.com/folke/which-key.nvim/commit/387fd676d3f9b419d38890820f6e262dc0fadb46))
* passing registers in INSERT mode, is not by pasting them 😅 [#62](https://github.com/folke/which-key.nvim/issues/62) ([342c8cd](https://github.com/folke/which-key.nvim/commit/342c8cdb3651967c96c356eb2d79561c0c9273ee))
* place popup correctly respecting cmdheight [#28](https://github.com/folke/which-key.nvim/issues/28) ([490e4d5](https://github.com/folke/which-key.nvim/commit/490e4d55315b74c63a63ada89ecf0e660a94db9a))
* possible nil value in health check ([b1627ca](https://github.com/folke/which-key.nvim/commit/b1627caa25e24c580bbc88377942353875f93a41))
* possible recursion ([f7fef32](https://github.com/folke/which-key.nvim/commit/f7fef32701aba0a822ac0a82679aea454bec702f))
* prevent double escaping of key codes ([1676611](https://github.com/folke/which-key.nvim/commit/167661151204ea7da2d365113a76ab223b3dc880))
* properly escape sequence ([2473329](https://github.com/folke/which-key.nvim/commit/24733293bb7b28f3d98d4a88323eb13cbe5b46f2))
* properly escape terminal chars to see if we already hooked a trigger ([1bee8a1](https://github.com/folke/which-key.nvim/commit/1bee8a151e72e5738d813964492248c9bbc4c5ba))
* properly format unicode text in columns (fixes [#66](https://github.com/folke/which-key.nvim/issues/66)) ([e3066fa](https://github.com/folke/which-key.nvim/commit/e3066facb6ed91ac013e4ff8faf24997ed44459c))
* properly handle &lt; chatracters (should be <lt&gt;) ([e618f84](https://github.com/folke/which-key.nvim/commit/e618f8403e615d4344f2964839ee0e2013b4253e))
* properly handle &lt; when loading WK [#16](https://github.com/folke/which-key.nvim/issues/16) ([6cf68b4](https://github.com/folke/which-key.nvim/commit/6cf68b49d48f2e07b82aee18ad01c4115d9ce0e5))
* properly handle &lt;lt&gt; when executing keys (fixes [#16](https://github.com/folke/which-key.nvim/issues/16) again) ([8500ebf](https://github.com/folke/which-key.nvim/commit/8500ebf69e30629fc0e00f4b52afefc0cfe38379))
* properly handle buffer=0 as the current buffer. Fixes [#91](https://github.com/folke/which-key.nvim/issues/91) ([9ea98e5](https://github.com/folke/which-key.nvim/commit/9ea98e59ddeeafc9181815dd714bea513b298e33))
* properly handle selected regsiters when executing keys [#36](https://github.com/folke/which-key.nvim/issues/36) ([5248a2d](https://github.com/folke/which-key.nvim/commit/5248a2db7e46803e8d8786f84b05280116cec707))
* properly parse internal key codes and key notation ([535703c](https://github.com/folke/which-key.nvim/commit/535703cd4f08623e12458b5522be1f4ec2a878e7))
* redraw after nvim_echo to fix issue with cmdheight=0 ([abcc2c6](https://github.com/folke/which-key.nvim/commit/abcc2c63f723b69c0b31ccacdfddbaf3a03e2c12))
* registers plugin for visual mode ([86a58ea](https://github.com/folke/which-key.nvim/commit/86a58eac6a3bc69f5aa373b29df993d14fda3307))
* remove unnecessary replacement of backslash ([#284](https://github.com/folke/which-key.nvim/issues/284)) ([7afe584](https://github.com/folke/which-key.nvim/commit/7afe58460305bc68515858c22d39368bc75984b3))
* removed debug code ([2f823b8](https://github.com/folke/which-key.nvim/commit/2f823b87293657b5c34cf94a0ef72af02d0117e7))
* removed feedkeys as typed, since some normal mappings stop working ([e6a63ec](https://github.com/folke/which-key.nvim/commit/e6a63ec73efffdc63ee9da84d8a1dd1cbdff4650))
* removed triggers_nowait from README since this really only makes sense for plugins ([69fcfff](https://github.com/folke/which-key.nvim/commit/69fcfffe48f859b4192c111756221f967c8876b5))
* Reset `+` and `*` to default register when clipboard is set ([#233](https://github.com/folke/which-key.nvim/issues/233)) ([8154e65](https://github.com/folke/which-key.nvim/commit/8154e6552ef3188efb6c68d968791ac90e8f2b76))
* reset op_count when it's 0 ([e3ad7c9](https://github.com/folke/which-key.nvim/commit/e3ad7c92743b9168abbe974100909e7e761bdacd))
* set noautocmd on the WhichKey window, so it works properly for other floats like Telescope ([36fdfe8](https://github.com/folke/which-key.nvim/commit/36fdfe833207c120997c669a2c51060813f2f8a7))
* set scheduled instantly ([dc9c3be](https://github.com/folke/which-key.nvim/commit/dc9c3be7acae2a486c117f5a9f6ada62b2243336))
* show correct level and sort on keys / group ([a372c63](https://github.com/folke/which-key.nvim/commit/a372c63d5551a3656b7fa4388bdaf456d0d2cbb5))
* show error when setup was not run ([194f788](https://github.com/folke/which-key.nvim/commit/194f788cae6b41fe7edf362b6030237a1c221beb))
* sort keys case insensitive [#25](https://github.com/folke/which-key.nvim/issues/25) ([e26be8c](https://github.com/folke/which-key.nvim/commit/e26be8c3cb876d634545ed7013c69f45f4e9375c))
* special handling needed when &lt;leader&gt; = <bslash> [#40](https://github.com/folke/which-key.nvim/issues/40) ([c4a59d7](https://github.com/folke/which-key.nvim/commit/c4a59d76135563ea73beb87cf0d6d7a3302563be))
* start of visual selection mark should be &lt;lt&gt; instead of < [#69](https://github.com/folke/which-key.nvim/issues/69) ([840311c](https://github.com/folke/which-key.nvim/commit/840311c272eda2c4fc0d92070e9ef2dd13f884e7))
* typo ([4bacbfd](https://github.com/folke/which-key.nvim/commit/4bacbfdacb9eebee339d36243fe17b9185ccbb74))
* use buffer instead of bufnr + added warning ([df49a59](https://github.com/folke/which-key.nvim/commit/df49a59efdfd6a90f412aa251914183fec8593af))
* use Comment as fallback color for the Separator ([7ee35a7](https://github.com/folke/which-key.nvim/commit/7ee35a7614e34e562fd3f815ad35bd6d7e456093))
* use config.key_labels for cmdline trail as well (Fixes [#108](https://github.com/folke/which-key.nvim/issues/108)) ([1872dd8](https://github.com/folke/which-key.nvim/commit/1872dd8ca9daa0f6478a7771087aedae8518cb97))
* use mode instead of redraw when cmdheight=0. (Fixes [#327](https://github.com/folke/which-key.nvim/issues/327)) ([c966279](https://github.com/folke/which-key.nvim/commit/c96627900191355e6788629bbf5239d7295221f0))
* use secret nop bindings to make sure timeoutlen is always respected ([eccd5f8](https://github.com/folke/which-key.nvim/commit/eccd5f8bf22e60620eee833946638b90552c9b69))
* use strwidth instead of strdisplaywidth ([386591e](https://github.com/folke/which-key.nvim/commit/386591e24afe88c1c52c2291d450e7d7ad9cf02a))


### Performance Improvements

* as long as we didnt finish loading, queue registers ([1bac978](https://github.com/folke/which-key.nvim/commit/1bac978464fd00dddbeee9c5584120f553b1a660))
* defer loading to VimEnter and only process hooks once when ready ([84ddcdc](https://github.com/folke/which-key.nvim/commit/84ddcdcd862c4bb6dcac84a876f66f9777ecef7c))
* no need to create triggers for all levels. first level that is not a cmd is enough ([3cc0424](https://github.com/folke/which-key.nvim/commit/3cc042498db5792b8f3b081310926c779c7aac07))
* no need to hook buffer-local if we have a global hook for a certain prefix ([bb5e0d9](https://github.com/folke/which-key.nvim/commit/bb5e0d9be9c73b7d343ff4bf0ffbb9b6b4696811))
* only load modules when needed ([6f8ae23](https://github.com/folke/which-key.nvim/commit/6f8ae23540bc5f980862d2d5aa6d3c02bb1e2da0))
