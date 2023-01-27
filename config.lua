Config = {}

Config.PlateLetters = 3
Config.PlateNumbers = 4
Config.PaukPayPrice = 5000


Config.Shops = {
    ['car'] = {
        marker = 36,
        entering = vector3(-43.18, -1104.51, 26.42),
        vehiclespawn = {coords = vector3(-27.1, -1082.39, 26.64), heading = 70.75},
        hint = 'Pritisnite <span><strong>E</strong></span> da otvorite <span>autosalon</span>',
        label = 'Salon automobila'
    },
    ['boat'] = {
        marker = 35,
        entering = vector3(-735.11, -1343.27, 1.57),
        vehiclespawn = {coords = vector3(0,0,0), heading = 0.0},
        hint = 'Pritisnite <span><strong>E</strong></span> da otvorite <span>salon brodova</span>',
        label = 'Salon brodova'
    },
}

Config.Garage = {
    ['glavna'] = {
        type = 'car',
        label = 'Glavna Garaza',
        hint = 'Pritisnite <span>E</span> da otvorite <span>Glavnu</span> garazu.',
        pos = vector3(-348.9, -874.69, 31.32),
        marker = 36,
        SpawnPoint = {x = -325.39, y = -879.09, z = 31.07},
        DeletePoint = {
            marker = 36,
            pos = vector3(-329.78, -904.71, 31.08)
        }
    },
    ['sandy'] = {
        type = 'car',
        label = 'Sandy Garaza',
        hint = 'Pritisnite <span>E</span> da otvorite <span>Sandy Shores</span> garazu.',
        pos = vector3(1737.7, 3710.19, 34.14),
        marker = 36,
        SpawnPoint = {x = 1726.66, y = 3723.86, z = 34.06},
        DeletePoint = {
            marker = {},
            pos = vector3(1727.84, 3710.79, 34.25)
        }
    },
    ['paleto'] = {
        type = 'car',
        label = 'Paleto Garaza',
        hint = 'glavna',
        pos = vector3(105.74, 6610.05, 31.92),
        marker = 36,
        SpawnPoint = {x = -1066.405, y = -2704.92, z = 20.19},
        DeletePoint = {
            marker = {},
            pos = vector3(117.59, 6599.52, 32.01)
        }
    },
    ['lossantos'] = {
        type = 'car',
        label = 'Garaza Los Santos',
        hint = 'Pritisnite <span>E</span> da otvorite <span>Los Santos</span> garazu.',
        pos = vector3(-1368.88, -465.0, 31.6),
        marker = 36,
        SpawnPoint = {x =-1371.82, y = -480.38, z = 31.59},
        DeletePoint = {
            marker = {},
            pos = vector3(-1362.46, -472.5, 31.6)
        }
    },
    ['glavnabrod'] = {
        type = 'boat',
        label = 'Glavna Luka',
        hint = 'Pritisnite <span>E</span> da otvorite <span>Glavnu</span> luku.',
        pos = vector3(-806.41, -1496.93, 1.6),
        marker = 35,
        SpawnPoint = {x = -1066.405, y = -2704.92, z = 20.19},
        DeletePoint = {
            marker = {},
            pos = vector3(117.59, 6599.52, 32.01)
        }
    },
    ['paletobrod'] = {
        type = 'boat',
        label = 'Paleto Luka',
        hint = 'Pritisnite <span>E</span> da otvorite <span>Paleto</span> luku.',
        pos = vector3(-284.65, 6629.06, 7.25),
        marker = 35,
        SpawnPoint = {x = -1066.405, y = -2704.92, z = 20.19},
        DeletePoint = {
            marker = {},
            pos = vector3(117.59, 6599.52, 32.01)
        }
    },
    ['sandybrod'] = {
        type = 'boat',
        label = 'Sandy Luka',
        hint = 'Pritisnite <span>E</span> da otvorite <span>Sandy</span> luku.',
        pos = vector3(3858.17, 4459.17, 1.82),
        marker = 35,
        SpawnPoint = {x = -1066.405, y = -2704.92, z = 20.19},
        DeletePoint = {
            marker = {},
            pos = vector3(117.59, 6599.52, 32.01)
        }
    },
    ['pauk'] = {
        type = 'car',
        label = 'Parking Servis',
        hint = 'Pritisnite <span>E</span> da otvorite <span>Parking Servis</span> garazu.',
        pos = vector3(409.35, -1623.12, 29.29),
        marker = 36,
        SpawnPoint = {x = 402.76, y = 1632.91, z = 29.29},
        DeletePoint = {
            marker = {},
            pos = vector3(0,0,0)
        }
    }
}