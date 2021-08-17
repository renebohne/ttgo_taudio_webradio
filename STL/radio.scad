$fn=100;


m=3;//material thickness

h_outer=50;
r_outer=(85+m)/2;
r_pir_sensor = 12/2;
h_ring = 3;
r_ring_inner = 54;
r_auflage = 68/2;


r_fr7_schrauben = 74/2;
h_fr7 = 28;

module lautsprecherhalterung()
{
    difference()
    {
        cylinder(h=3,r=r_outer,center=true);
        cylinder(h=4,r=63/2,center=true);
        //Schrauben
        for(i=[0:3])
        {
        rotate(a=[0,0,i*90])translate([r_fr7_schrauben,0,0])cylinder(h=20,r=4/2,center=true);
        }
    }
}

module lautsprecherbox_top()
{
    translate([0,0,3.5])lautsprecherbox_topB();
    lautsprecherhalterung();
}

module lautsprecherbox_topA()
{
    difference()
    {
        cylinder(h=2,r=r_outer,center=true);
        translate([0,0,-.5/2+0.1]) cylinder(h=50,r=60/2,center=true);
    }
    
    for(i=[0:3])
    {
     rotate(a=[0,0,i*90])   translate([83/2-3/2,0,3/2]) cube([3,3,3],center=true);
    }
   
    
}

module lautsprecherbox_topB()
{
    difference()
    {
        cylinder(h=4,r=r_outer,center=true);
        translate([0,0,-.5/2+0.1]) cylinder(h=5,r=83/2,center=true);
     
        
    }
}

module lautsprecherbox_gitter()
{
    difference()
    {
        cylinder(h=2,r=r_fr7_schrauben+4/2-1,center=true);
      
        cylinder(h=4,r=63/2,center=true);
         
        /*
        for(i=[0:7])
        {
        translate([- (r_fr7_schrauben+20)/2 +   10*i,0,0])cube([3,30,20],center=true);
        }
        */
    }
}


module lautsprecherbox_bottom()
{
    difference()
    {
        cylinder(h=h_fr7+2,r=r_outer,center=true);
        translate([0,0,2])cylinder(h=h_fr7,r=r_outer-6/2,center=true);
        
           cylinder(h=h_fr7+4*2,r=r_ring_inner/2-m,center=true);
        
    }
}






module auflage()
{
    difference()
    {
        cylinder(h=3, r=r_outer, center=true);
        translate([0,0,0]) cylinder(h=4, r=r_auflage, center=true);
    }
}


module ring()
{
    difference()
    {
        cylinder(h=h_ring, r=r_outer, center=true);
        translate([0,0,0]) cylinder(h=2*h_ring, r=r_ring_inner/2-m, center=true);
    }
}

module bottom()
{
    difference()
    {
      
        translate([0,0,0])cylinder(h=h_fr7, r=r_outer, center=true);
        translate([0,0,2])cylinder(h=h_fr7, r=r_outer-3, center=true);
        translate([r_outer,0,h_fr7/2-9/2+0.1])cube([13,13,9],center=true);//USB
    }
    
    translate([0,0,h_fr7/2-3/2-8])
    {
        difference()
        {
            auflage();
            translate([r_outer-6,0,0])cube([13,13,9],center=true);//USB
        }
    }
}

color("#F0F0FF")translate([0,0,3/2+9/2+2]) rotate(a=[0,180,0]) lautsprecherbox_topA();
translate([0,0,0])color("#6666FF") rotate(a=[0,0,0])lautsprecherbox_top();
color("#00FF00")translate([0,0,-20])lautsprecherbox_bottom();
color("#FFFFFF")translate([0,0,-40]) ring();
translate([0,0,-60]) bottom();