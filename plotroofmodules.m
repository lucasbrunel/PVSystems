m_ix1 = [1,2,6,7,11,12,16,17,21,22,26,27,31,32,36,37];
m_ix2 = [1:40];
irr_1_l_act = zeros(1,16);
for i = 1:16
    irr_1_l_act(i) = irr_1_l(m_ix1(i));
end

plotModulesOnRoof('landscape_modules', 2, m_ix2, 'irradiation', irr_2_l, cb_limits);
hold on
plotModulesOnRoof('landscape_modules', 1, m_ix1, 'irradiation', irr_1_l_act, cb_limits);
