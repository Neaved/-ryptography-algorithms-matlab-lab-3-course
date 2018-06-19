%Фейстель +
rounds = 12;
src = '0x15FCEEAA231F06A5';
x1 = hexToBinaryVector(src,64);
s = cell(8,1);
s{1} = '0x2A4D507BF9C1E683';s{2} = '0x2DC97BF41306E5A8';
s{3} = '0x70C13A658492BEFD';s{4} = '0x4F91DC576AEB3082';
s{5} = '0x0F369E18275DCA4B';s{6} = '0x3A0985BD2F4CE617';
s{7} = '0xBD73F508942E6CA1';s{8} = '0xA53C8761FED492B0';
pt = [9 24 19 17 3 7 32 2 14 12 26 22 1 18 28 11 6 13 29 21 16 23 30 25 20 10 4 8 27 5 15 31];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ROUND KEYs GENERATION   %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textKey = '0xE10430A6';
binaryKey = hexToBinaryVector(textKey,32);
keySet = cell(rounds,1);
keySet{1} = binaryKey;
tmp = binaryVectorToHex(keySet{1});
for i = 2:rounds
%    keySet{i} = hexToBinaryVector(dec2hex(mod(7+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^2,2^32)),32);
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
 
   %display(binaryVectorToHex(right), 'right')
   %display(binaryVectorToHex(keySet{i}), 'key')
    
   tmpR =  num2str(dec2hex(hex2dec(binaryVectorToHex(right))+ hex2dec(binaryVectorToHex(keySet{i}))));
    
   if(length(tmpR) > 8)
       tmpR(1) = [];
   end
   
   tmpR;
   
   for j=1:length(tmpR)
       tmpR(j) = s{j}(hex2dec(tmpR(j))+1+2);
   end
    
   tmpR = hexToBinaryVector(tmpR,32);
   
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
%                               

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        DECRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%left1 = encrypted(1:32);
%right1 = encrypted(33:64);
% 
left1 = x1(1:32);
right1 = x1(33:64);

for i = 1:rounds
   
%   dDataRplusKBin = input('dRightPlusKeySetBin = ');
%   tmpR = num2str(binaryVectorToHex(dDataRplusKBin))
    
    tmpR =  num2str(dec2hex(hex2dec(binaryVectorToHex(right1)) + hex2dec(binaryVectorToHex(keySet{rounds-i+1}))));
    
    if(length(tmpR) > 8)
        tmpR(1) = [];
    end
   
    tmpR;
    
    for j=1:length(tmpR)
        tmpR(j) = s{j}(hex2dec(tmpR(j))+1+2);
    end
    tmpR = hexToBinaryVector(tmpR,32);
    
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