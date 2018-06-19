% Фейстиль xor
rounds = 10;
src = '0x5CF717C29E9BC601';
x1 = hexToBinaryVector(src,64);
s = cell(8,1);
s{1} = '0x95A328641B0DE7CF';s{2} = '0x1B903A25ED8CF746';
s{3} = '0x0BFD2C968A457E13';s{4} = '0x071F26B3E98C54DA';
s{5} = '0xEBC6803197F4DA52';s{6} = '0xBF1834CA7652ED90';
s{7} = '0x4E93A21856B7CF0D';s{8} = '0x1B7D5439FEC8062A';
pt = [3 16 9 12 10 14 15 1 28 11 32 17 27 7 13 24 25 23 20 4 19 6 18 22 26 29 5 2 21 31 30 8];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ROUND KEYs GENERATION   %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textKey = '0xF33437DB';
binaryKey = hexToBinaryVector(textKey,32);
keySet = cell(rounds,1);
keySet{1} = binaryKey;
tmp = binaryVectorToHex(keySet{1});
for i = 2:rounds
  %  keySet{i} = hexToBinaryVector(dec2hex(mod(7+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^2,2^32)),32);
    keySet{i} = hexToBinaryVector(dec2hex(mod(11111+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^3,2^32)),32);
%     sM = zeros(1,11);
%     keySet{i} = zeros(1,32);
%     sM = keySet{i-1}(1:11);
%     k = 1;
%     
%     for j=1:32
%         if (j < 22)
%             keySet{i}(j) = keySet{i-1}(j+11);
%         else
%             keySet{i}(j) = sM(k);
%             k = k + 1;
%         end
%     end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ENCRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left = x1(1:32);
right = x1(33:64);
for i = 1:rounds
    % SP -substitution for right block
    % S - substitution
    tmpR = num2str( binaryVectorToHex(xor(right, keySet{i})));
    for j=1:length(tmpR)
        tmpR(j) = s{j}(hex2dec(tmpR(j))+1+2);
    end
    tmpR = hexToBinaryVector(tmpR,32);
    % P - substitution
    temp = tmpR;
    for j=1:length(tmpR)
        tmpR(j) = temp(pt(j));
    end
    
    tmp = right;
    right = xor(tmpR,left);
    left = tmp;   
   
end

encrypted(1:32) = right;
encrypted(33:64) = left;
binaryVectorToHex(encrypted)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        DECRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%left1 = encrypted(1:32);
%right1 = encrypted(33:64);
left1 = x1(1:32);
right1 = x1(33:64);
for i = 1:rounds
    % SP -substitution for right block
    % S - substitution
    tmpR = num2str( binaryVectorToHex(xor(right1, keySet{rounds-i+1})));
    for j=1:length(tmpR)
        tmpR(j) = s{j}(hex2dec(tmpR(j))+1+2);
    end
    tmpR = hexToBinaryVector(tmpR,32);
    % P - substitution
    temp = tmpR;
    for j=1:length(tmpR)
        tmpR(j) = temp(pt(j));
    end
    
    tmp = right1;
    right1 = xor(tmpR,left1);
    left1 = tmp;   
   
end
decrypted(1:32) = right1;
decrypted(33:64) = left1;
binaryVectorToHex(decrypted)
