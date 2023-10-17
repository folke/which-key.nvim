# Changelog

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
