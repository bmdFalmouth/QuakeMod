void() spawn_coffee =
{
    precache_model ("progs/Coffee.mdl");
    setmodel (self, "progs/Coffee.mdl");
    setsize (self, '-16 -16 0', '16 16 32');
    self.solid =  SOLID_BBOX;
    self.movetype = MOVETYPE_NONE;
};

void() spawn_coffee_cmd =
{
    spawn_coffee();
};
