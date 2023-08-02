// Auto-generated
let project = new Project('Game_1_0_0');

project.addSources('Sources');
project.addLibrary("C:/Workspace/armsdk/armory");
project.addLibrary("C:/Workspace/armsdk/iron");
project.addLibrary("C:/Workspace/armsdk/lib/haxebullet");
project.addAssets("C:/Workspace/armsdk/lib/haxebullet/ammo/ammo.wasm.js", { notinlist: true });
project.addAssets("C:/Workspace/armsdk/lib/haxebullet/ammo/ammo.wasm.wasm", { notinlist: true });
project.addLibrary("C:/Workspace/armsdk/lib/haxerecast");
project.addAssets("C:/Workspace/armsdk/lib/haxerecast/js/recast/recast.js", { notinlist: true });
project.addParameter('armory.trait.physics.bullet.PhysicsWorld');
project.addParameter("--macro keep('armory.trait.physics.bullet.PhysicsWorld')");
project.addParameter('arm.node.FistLogic');
project.addParameter("--macro keep('arm.node.FistLogic')");
project.addParameter('armory.trait.internal.UniformsManager');
project.addParameter("--macro keep('armory.trait.internal.UniformsManager')");
project.addParameter('armory.trait.navigation.Navigation');
project.addParameter("--macro keep('armory.trait.navigation.Navigation')");
project.addParameter('arm.PlayerLogic');
project.addParameter("--macro keep('arm.PlayerLogic')");
project.addParameter('arm.DoorLogic');
project.addParameter("--macro keep('arm.DoorLogic')");
project.addParameter('armory.trait.NavMesh');
project.addParameter("--macro keep('armory.trait.NavMesh')");
project.addParameter('armory.trait.internal.CanvasScript');
project.addParameter("--macro keep('armory.trait.internal.CanvasScript')");
project.addParameter('arm.GameCanvasLogic');
project.addParameter("--macro keep('arm.GameCanvasLogic')");
project.addParameter('arm.HuggyLogic');
project.addParameter("--macro keep('arm.HuggyLogic')");
project.addParameter('armory.trait.physics.bullet.RigidBody');
project.addParameter("--macro keep('armory.trait.physics.bullet.RigidBody')");
project.addParameter('armory.trait.NavAgent');
project.addParameter("--macro keep('armory.trait.NavAgent')");
project.addParameter('arm.node.BoneIK');
project.addParameter("--macro keep('arm.node.BoneIK')");
project.addShaders("build_Game/compiled/Shaders/*.glsl", { noembed: false});
project.addShaders("build_Game/compiled/Hlsl/*.glsl", { noprocessing: true, noembed: false });
project.addAssets("build_Game/compiled/Assets/**", { notinlist: true });
project.addAssets("build_Game/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("Art/Policeman/Aim.png", { notinlist: true });
project.addAssets("Art/Policeman/Ammo.png", { notinlist: true });
project.addAssets("Art/Policeman/Photo.png", { notinlist: true });
project.addAssets("Art/Policeman/Pistol.png", { notinlist: true });
project.addAssets("Art/Policeman/heart-empty.png", { notinlist: true });
project.addAssets("Art/Policeman/heart-full.png", { notinlist: true });
project.addAssets("Bundled/canvas/GameCanvas.files", { notinlist: true });
project.addAssets("Bundled/canvas/GameCanvas.json", { notinlist: true });
project.addAssets("Bundled/canvas/_themes.json", { notinlist: true });
project.addAssets("C:/Downloads/128x128/Brick/Brick_08-128x128.png", { notinlist: true });
project.addAssets("C:/Downloads/128x128/Plaster/Plaster_01-128x128.png", { notinlist: true });
project.addAssets("C:/Downloads/128x128/Wood/Wood_01-128x128.png", { notinlist: true });
project.addAssets("C:/Downloads/128x128/Wood/Wood_19-128x128.png", { notinlist: true });
project.addAssets("C:/Workspace/VisitingHagiVaga/Art/Policeman/MuzzleFlash.png", { notinlist: true });
project.addAssets("C:/Workspace/armsdk/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("C:/Workspace/armsdk/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("C:/Workspace/armsdk/armory/Assets/smaa_search.png", { notinlist: true });
project.addLibrary("C:/Workspace/armsdk/lib/zui");
project.addAssets("C:/Workspace/armsdk/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('arm_deferred');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=Off');
project.addDefine('rp_translucency');
project.addDefine('rp_gbuffer_emission');
project.addDefine('js-es=6');
project.addDefine('arm_physics');
project.addDefine('arm_bullet');
project.addDefine('arm_navigation');
project.addDefine('arm_assert_level=Warning');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_audio');
project.addDefine('arm_ui');
project.addDefine('arm_skin');
project.addDefine('arm_morph_target');
project.addDefine('arm_particles');
project.addDefine('armory');


resolve(project);
