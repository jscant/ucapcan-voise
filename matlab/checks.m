clc; clear all; format compact;
new = load("VDNew.mat");
old = load("VDOld.mat");
new = new.VDNew;
old = old.VDOld;

differences = compareVD(new, old, 1);

return;