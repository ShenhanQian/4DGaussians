ModelHiddenParams = dict(
    kplanes_config = {
     'grid_dimensions': 2,
     'input_coordinate_dim': 4,
     'output_coordinate_dim': 16,
     'resolution': [128, 128, 128, 2]
    },
    multires = [1,2,4],
    defor_depth = 1,
    net_width = 128,
    plane_tv_weight = 0,  #0.0002,
    time_smoothness_weight = 0, #0.001,  # causing nan
    l1_time_planes =  0,  #0.0001,
    render_process=False
)
OptimizationParams = dict(
    # dataloader=True,
    iterations = 10_000,
    batch_size=2,
    coarse_iterations = 3000,
    densify_until_iter = 6_000,
    opacity_reset_interval = 300000,
    position_lr_init = 0.00016,
    position_lr_final = 0.0000016,
    position_lr_max_steps = 10_000,
    deformation_lr_init = 0.00016,
    deformation_lr_final = 0.000016,
    grid_lr_init = 0.0016,
    grid_lr_final = 0.00016,
    scaling_lr = 0.005,
)