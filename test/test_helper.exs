ExUnit.start()

Registry.start_link(keys: :unique, name: GameOfLife.CellRegistry)
