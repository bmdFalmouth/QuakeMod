void() spawn_coffee =
{
    setmodel (self, "progs/Coffee.mdl");
    setsize (self, '-16 -16 0', '16 16 32');
    self.movetype = MOVETYPE_NONE;
};

void() spawn_coffee_cmd =
{
    spawn_coffee();
};
