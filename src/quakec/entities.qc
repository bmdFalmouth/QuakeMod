void coffee_think() =
{
    self.angles_y = self.angles_y + 10 * frametime;
    self.nextthink=time+0.01;
}

void() spawn_coffee =
{
    setmodel (self, "progs/Coffee.mdl");
    setsize (self, '-16 -16 0', '16 16 32');
    self.movetype = MOVETYPE_NONE;
    self.solid=SOLID_SLIDEBOX;
    self.think=coffee_think;
    self.nextthink=time+0.01;

};

void() spawn_coffee_cmd =
{
    spawn_coffee();
};
